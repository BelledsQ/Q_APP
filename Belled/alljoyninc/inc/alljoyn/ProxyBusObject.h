#ifndef _ALLJOYN_REMOTEBUSOBJECT_H
#define _ALLJOYN_REMOTEBUSOBJECT_H
/**
 * @file
 * This file defines the class ProxyBusObject.
 * The ProxyBusObject represents a single object registered  registered on the bus.
 * ProxyBusObjects are used to make method calls on these remotely located DBus objects.
 */

/******************************************************************************
 * Copyright (c) 2009-2013, AllSeen Alliance. All rights reserved.
 *
 *    Permission to use, copy, modify, and/or distribute this software for any
 *    purpose with or without fee is hereby granted, provided that the above
 *    copyright notice and this permission notice appear in all copies.
 *
 *    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 ******************************************************************************/

#include <qcc/platform.h>
#include <qcc/String.h>
#include <alljoyn/InterfaceDescription.h>
#include <alljoyn/MessageReceiver.h>
#include <alljoyn/MsgArg.h>
#include <alljoyn/Message.h>
#include <alljoyn/Session.h>

#include <alljoyn/Status.h>

namespace qcc {
/** @internal Forward references */
class Mutex;
}

namespace ajn {

/** @internal Forward references */
class BusAttachment;

/**
 * Each %ProxyBusObject instance represents a single DBus/AllJoyn object registered
 * somewhere on the bus. ProxyBusObjects are used to make method calls on these
 * remotely located DBus objects.
 */
class ProxyBusObject : public MessageReceiver {
    friend class XmlHelper;
    friend class AllJoynObj;

  public:

    /**
     * The default timeout for method calls (25 seconds)
     */
    static const uint32_t DefaultCallTimeout = 25000;

    /**
     * Pure virtual base class implemented by classes that wish to receive
     * ProxyBusObject related messages.
     *
     * @internal Do not use this pattern for creating public Async versions of the APIs.  See
     * BusAttachment::JoinSessionAsync() instead.
     */
    class Listener {
      public:
        /**
         * Callback registered with IntrospectRemoteObjectAsync()
         *
         * @param status    ER_OK if successful or an error status indicating the reason for the failure.
         * @param obj       Remote bus object that was introspected
         * @param context   Context passed in IntrospectRemoteObjectAsync()
         */
        typedef void (ProxyBusObject::Listener::* IntrospectCB)(QStatus status, ProxyBusObject* obj, void* context);

        /**
         * Callback registered with GetPropertyAsync()
         *
         * @param status    - ER_OK if the property get request was successfull or:
         *                  - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the specified interfaces does not exist on the remote object.
         *                  - #ER_BUS_NO_SUCH_PROPERTY if the property does not exist
         *                  - Other error status codes indicating the reason the get request failed.
         * @param obj       Remote bus object that was introspected
         * @param value     If status is ER_OK a MsgArg containing the returned property value
         * @param context   Caller provided context passed in to GetPropertyAsync()
         */
        typedef void (ProxyBusObject::Listener::* GetPropertyCB)(QStatus status, ProxyBusObject* obj, const MsgArg& value, void* context);

        /**
         * Callback registered with GetAllPropertiesAsync()
         *
         * @param status      - ER_OK if the get all properties request was successfull or:
         *                  - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the specified interfaces does not exist on the remote object.
         *                  - Other error status codes indicating the reason the get request failed.
         * @param obj         Remote bus object that was introspected
         * @param[out] values If status is ER_OK an array of dictionary entries, signature "a{sv}" listing the properties.
         * @param context     Caller provided context passed in to GetPropertyAsync()
         */
        typedef void (ProxyBusObject::Listener::* GetAllPropertiesCB)(QStatus status, ProxyBusObject* obj, const MsgArg& values, void* context);

        /**
         * Callback registered with SetPropertyAsync()
         *
         * @param status    - ER_OK if the property was successfully set or:
         *                  - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the specified interfaces does not exist on the remote object.
         *                  - #ER_BUS_NO_SUCH_PROPERTY if the property does not exist
         *                  - Other error status codes indicating the reason the set request failed.
         * @param obj       Remote bus object that was introspected
         * @param context   Caller provided context passed in to SetPropertyAsync()
         */
        typedef void (ProxyBusObject::Listener::* SetPropertyCB)(QStatus status, ProxyBusObject* obj, void* context);
    };

    /**
     * Create a default (unusable) %ProxyBusObject.
     *
     * This constructor exist only to support assignment.
     */
    ProxyBusObject();

    /**
     * Create an empty proxy object that refers to an object at given remote service name. Note
     * that the created proxy object does not contain information about the interfaces that the
     * actual remote object implements with the exception that org.freedesktop.DBus.Peer
     * interface is special-cased (per the DBus spec) and can always be called on any object. Nor
     * does it contain information about the child objects that the actual remote object might
     * contain. The security mode can be specified if known or can be derived from the XML
     * description.
     *
     * See also these sample file(s): @n
     * simple/android/client/jni/Client_jni.cpp @n
     * windows/PhotoChat/AllJoynBusLib/AllJoynConnection.cpp @n
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/src/MediaSink.cc @n
     * cpp/Basic/Basic_Client/BasicClient/MainPage.xaml.cpp @n
     * cpp/Basic/Name_Change_Client/NameChangeClient/MainPage.xaml.cpp @n
     * cpp/Secure/Secure/MainPage.xaml.cpp @n
     * csharp/Basic/Basic_Client/BasicClient/MainPage.xaml.cs @n
     * csharp/Basic/Name_Change_Client/NameChangeClient/MainPage.xaml.cs @n
     * csharp/BusStress/BusStress/Common/StressOperation.cs @n
     * csharp/Secure/Secure/Common/Client.cs @n
     * javascript/Basic/Basic_Client/BasicClient/js/AlljoynObjects.js @n
     * javascript/Basic/Name_Change_Client/NameChangeClient/js/AlljoynObjects.js @n
     * javascript/Secure/Secure/js/Client.js @n
     *
     * To fill in this object with the interfaces and child object names that the actual remote
     * object describes in its introspection data, call IntrospectRemoteObject() or
     * IntrospectRemoteObjectAsync().
     *
     * @param bus        The bus.
     * @param service    The remote service name (well-known or unique).
     * @param path       The absolute (non-relative) object path for the remote object.
     * @param sessionId  The session id the be used for communicating with remote object.
     * @param secure     The security mode for the remote object.
     */
    ProxyBusObject(BusAttachment& bus, const char* service, const char* path, SessionId sessionId, bool secure = false);

    /**
     *  %ProxyBusObject destructor.
     */
    virtual ~ProxyBusObject();

    /**
     * Return the absolute object path for the remote object.
     *
     * @return Object path
     */
    const qcc::String& GetPath(void) const { return path; }

    /**
     * Return the remote service name for this object.
     *
     * @return Service name (typically a well-known service name but may be a unique name)
     */
    const qcc::String& GetServiceName(void) const { return serviceName; }

    /**
     * Return the session Id for this object.
     *
     * For Windows 8 see also these sample file(s): @n
     * csharp/Sessions/Sessions/Common/SessionOperations.cs @n
     * csharp/Sessions/Sessions/MainPage.xaml.cs @n
     *
     * @return Session Id
     */
    SessionId GetSessionId(void) const { return sessionId; }

    /**
     * Query the remote object on the bus to determine the interfaces and
     * children that exist. Use this information to populate this proxy's
     * interfaces and children.
     *
     * See also these sample file(s): @n
     * basic/nameChange_client.cc @n
     *
     * @param timeout   Timeout specified in milliseconds to wait for a reply
     *
     * @return
     *      - #ER_OK if successful
     *      - An error status otherwise
     */
    QStatus IntrospectRemoteObject(uint32_t timeout = DefaultCallTimeout);

    /**
     * Query the remote object on the bus to determine the interfaces and
     * children that exist. Use this information to populate this object's
     * interfaces and children.
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/src/MediaSink.cc @n
     * cpp/Basic/Basic_Client/BasicClient/MainPage.xaml.cpp @n
     * cpp/Basic/Name_Change_Client/NameChangeClient/MainPage.xaml.cpp @n
     * cpp/Secure/Secure/MainPage.xaml.cpp @n
     * csharp/Basic/Basic_Client/BasicClient/MainPage.xaml.cs @n
     * csharp/Basic/Name_Change_Client/NameChangeClient/MainPage.xaml.cs @n
     * csharp/BusStress/BusStress/Common/StressOperation.cs @n
     *
     * This call executes asynchronously. When the introspection response
     * is received from the actual remote object, this ProxyBusObject will
     * be updated and the callback will be called.
     *
     * This call exists primarily to allow introspection of remote objects
     * to be done inside AllJoyn method/signal/reply handlers and ObjectRegistered
     * callbacks.
     *
     * @param listener  Pointer to the object that will receive the callback.
     * @param callback  Method on listener that will be called.
     * @param context   User defined context which will be passed as-is to callback.
     * @param timeout   Timeout specified in milliseconds to wait for a reply
     * @return
     *      - #ER_OK if successful.
     *      - An error status otherwise
     */
    QStatus IntrospectRemoteObjectAsync(ProxyBusObject::Listener* listener, ProxyBusObject::Listener::IntrospectCB callback, void* context, uint32_t timeout = DefaultCallTimeout);

    /**
     * Get a property from an interface on the remote object.
     *
     * @param iface       Name of interface to retrieve property from.
     * @param property    The name of the property to get.
     * @param[out] value  Property value.
     * @param timeout     Timeout specified in milliseconds to wait for a reply
     *
     * @return
     *      - #ER_OK if the property was obtained.
     *      - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the no such interface on this remote object.
     *      - #ER_BUS_NO_SUCH_PROPERTY if the property does not exist
     */
    QStatus GetProperty(const char* iface, const char* property, MsgArg& value, uint32_t timeout = DefaultCallTimeout) const;

    /**
     * Make an asynchronous request to get a property from an interface on the remote object.
     * The property value is passed to the callback function.
     *
     * @param iface     Name of interface to retrieve property from.
     * @param property  The name of the property to get.
     * @param listener  Pointer to the object that will receive the callback.
     * @param callback  Method on listener that will be called.
     * @param context   User defined context which will be passed as-is to callback.
     * @param timeout   Timeout specified in milliseconds to wait for a reply
     * @return
     *      - #ER_OK if the request to get the property was successfully issued .
     *      - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the no such interface on this remote object.
     *      - An error status otherwise
     */
    QStatus GetPropertyAsync(const char* iface,
                             const char* property,
                             ProxyBusObject::Listener* listener,
                             ProxyBusObject::Listener::GetPropertyCB callback,
                             void* context,
                             uint32_t timeout = DefaultCallTimeout);

    /**
     * Get all properties from an interface on the remote object.
     *
     * @param iface       Name of interface to retrieve all properties from.
     * @param[out] values Property values returned as an array of dictionary entries, signature "a{sv}".
     * @param timeout     Timeout specified in milliseconds to wait for a reply
     *
     * @return
     *      - #ER_OK if the property was obtained.
     *      - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the no such interface on this remote object.
     *      - #ER_BUS_NO_SUCH_PROPERTY if the property does not exist
     */
    QStatus GetAllProperties(const char* iface, MsgArg& values, uint32_t timeout = DefaultCallTimeout) const;

    /**
     * Make an asynchronous request to get all properties from an interface on the remote object.
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/src/MediaSink.cc @n
     *
     * @param iface     Name of interface to retrieve property from.
     * @param listener  Pointer to the object that will receive the callback.
     * @param callback  Method on listener that will be called.
     * @param context   User defined context which will be passed as-is to callback.
     * @param timeout   Timeout specified in milliseconds to wait for a reply
     * @return
     *      - #ER_OK if the request to get all properties was successfully issued .
     *      - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the no such interface on this remote object.
     *      - An error status otherwise
     */
    QStatus GetAllPropertiesAsync(const char* iface,
                                  ProxyBusObject::Listener* listener,
                                  ProxyBusObject::Listener::GetPropertyCB callback,
                                  void* context,
                                  uint32_t timeout = DefaultCallTimeout);

    /**
     * Set a property on an interface on the remote object.
     *
     * See also these sample file(s): @n
     * basic/nameChange_client.cc @n
     *
     * @param iface     Remote object's interface on which the property is defined.
     * @param property  The name of the property to set
     * @param value     The value to set
     * @param timeout   Timeout specified in milliseconds to wait for a reply
     *
     * @return
     *      - #ER_OK if the property was set
     *      - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the specified interfaces does not exist on the remote object.
     *      - #ER_BUS_NO_SUCH_PROPERTY if the property does not exist
     */
    QStatus SetProperty(const char* iface, const char* property, MsgArg& value, uint32_t timeout = DefaultCallTimeout) const;

    /**
     * Make an asynchronous request to set a property on an interface on the remote object.
     * A callback function reports the success or failure of ther operation.
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/Basic/Name_Change_Client/NameChangeClient/MainPage.xaml.cpp @n
     * csharp/Basic/Name_Change_Client/NameChangeClient/MainPage.xaml.cs @n
     *
     * @param iface     Remote object's interface on which the property is defined.
     * @param property  The name of the property to set.
     * @param value     The value to set
     * @param listener  Pointer to the object that will receive the callback.
     * @param callback  Method on listener that will be called.
     * @param context   User defined context which will be passed as-is to callback.
     * @param timeout   Timeout specified in milliseconds to wait for a reply
     * @return
     *      - #ER_OK if the request to set the property was successfully issued .
     *      - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the specified interfaces does not exist on the remote object.
     *      - An error status otherwise
     */
    QStatus SetPropertyAsync(const char* iface,
                             const char* property,
                             MsgArg& value,
                             ProxyBusObject::Listener* listener,
                             ProxyBusObject::Listener::SetPropertyCB callback,
                             void* context,
                             uint32_t timeout = DefaultCallTimeout);

    /**
     * Helper function to sychronously set a uint32 property on the remote object.
     *
     * @param iface     Remote object's interface on which the property is defined.
     * @param property  The name of the property to set
     * @param u         The uint32 value to set
     * @param timeout   Timeout specified in milliseconds to wait for a reply
     *
     * @return
     *      - #ER_OK if the property was set
     *      - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the specified interfaces does not exist on the remote object.
     *      - #ER_BUS_NO_SUCH_PROPERTY if the property does not exist
     */
    QStatus SetProperty(const char* iface, const char* property, uint32_t u, uint32_t timeout = DefaultCallTimeout) const {
        MsgArg arg("u", u); return SetProperty(iface, property, arg, timeout);
    }

    /**
     * Helper function to sychronously set an int32 property on the remote object.
     *
     * @param iface     Remote object's interface on which the property is defined.
     * @param property  The name of the property to set
     * @param i         The int32 value to set
     * @param timeout   Timeout specified in milliseconds to wait for a reply
     *
     * @return
     *      - #ER_OK if the property was set
     *      - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the specified interfaces does not exist on the remote object.
     *      - #ER_BUS_NO_SUCH_PROPERTY if the property does not exist
     */
    QStatus SetProperty(const char* iface, const char* property, int32_t i, uint32_t timeout = DefaultCallTimeout) const {
        MsgArg arg("i", i); return SetProperty(iface, property, arg, timeout);
    }

    /**
     * Helper function to sychronously set string property on the remote object from a C string.
     *
     * See also these sample file(s): @n
     * basic/nameChange_client.cc @n
     *
     * @param iface     Remote object's interface on which the property is defined.
     * @param property  The name of the property to set
     * @param s         The string value to set
     * @param timeout   Timeout specified in milliseconds to wait for a reply
     *
     * @return
     *      - #ER_OK if the property was set
     *      - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the specified interfaces does not exist on the remote object.
     *      - #ER_BUS_NO_SUCH_PROPERTY if the property does not exist
     */
    QStatus SetProperty(const char* iface, const char* property, const char* s, uint32_t timeout = DefaultCallTimeout) const {
        MsgArg arg("s", s); return SetProperty(iface, property, arg, timeout);
    }

    /**
     * Helper function to sychronously set string property on the remote object from a qcc::String.
     *
     * @param iface     Remote object's interface on which the property is defined.
     * @param property  The name of the property to set
     * @param s         The string value to set
     * @param timeout   Timeout specified in milliseconds to wait for a reply
     *
     * @return
     *      - #ER_OK if the property was set
     *      - #ER_BUS_OBJECT_NO_SUCH_INTERFACE if the specified interfaces does not exist on the remote object.
     *      - #ER_BUS_NO_SUCH_PROPERTY if the property does not exist
     */
    QStatus SetProperty(const char* iface, const char* property, const qcc::String& s, uint32_t timeout = DefaultCallTimeout) const {
        MsgArg arg("s", s.c_str()); return SetProperty(iface, property, arg, timeout);
    }

    /**
     * Returns the interfaces implemented by this object. Note that all proxy bus objects
     * automatically inherit the "org.freedesktop.DBus.Peer" which provides the built-in "ping"
     * method, so this method always returns at least that one interface.
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/src/MediaSink.cc @n
     *
     * @param ifaces     A pointer to an InterfaceDescription array to receive the interfaces. Can be NULL in
     *                   which case no interfaces are returned and the return value gives the number
     *                   of interface available.
     * @param numIfaces  The size of the InterfaceDescription array. If this value is smaller than the total
     *                   number of interfaces only numIfaces will be returned.
     *
     * @return  The number of interfaces returned or the total number of interfaces if ifaces is NULL.
     */
    size_t GetInterfaces(const InterfaceDescription** ifaces = NULL, size_t numIfaces = 0) const;

    /**
     * Returns a pointer to an interface description. Returns NULL if the object does not implement
     * the requested interface.
     *
     * See also these sample file(s): @n
     * basic/basic_client.cc @n
     * basic/basic_service.cc @n
     * chat/android/jni/Chat_jni.cpp @n
     * chat/linux/chat.cc @n
     * secure/DeskTopSharedKSClient.cc @n
     * secure/DeskTopSharedKSService.cc @n
     * simple/android/service/jni/Service_jni.cpp @n
     * windows/chat/ChatLib32/ChatClasses.cpp @n
     * windows/Client/Client.cpp @n
     * windows/PhotoChat/AllJoynBusLib/AllJoynConnection.cpp @n
     * windows/Service/Service.cpp @n
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/src/MediaCommon.cc @n
     * cpp/Basic/Basic_Client/BasicClient/MainPage.xaml.cpp @n
     * cpp/Basic/Basic_Service/BasicService/AllJoynObjects.cpp @n
     * cpp/Basic/Signal_Consumer_Client/SignalConsumerClient/AllJoynObjects.cpp @n
     * cpp/Basic/Signal_Service/SignalService/AllJoynObjects.cpp @n
     * cpp/Chat/Chat/AllJoynObjects.cpp @n
     * cpp/Secure/Secure/MainPage.xaml.cpp @n
     * csharp/Basic/Basic_Client/BasicClient/MainPage.xaml.cs @n
     * csharp/Basic/Signal_Consumer_Client/SignalConsumerClient/Common/SignalConsumerBusListener.cs @n
     * csharp/BusStress/BusStress/Common/StressOperation.cs @n
     * csharp/chat/chat/Common/ChatSessionObject.cs @n
     * csharp/FileTransfer/Client/Common/FileTransferBusObject.cs @n
     * csharp/Secure/Secure/Common/Client.cs @n
     *
     * @param iface  The name of interface to get.
     *
     * @return
     *      - A pointer to the requested interface description.
     *      - NULL if requested interface is not implemented or not found
     */
    const InterfaceDescription* GetInterface(const char* iface) const;

    /**
     * Tests if this object implements the requested interface.
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/src/MediaSink.cc @n
     *
     * @param iface  The interface to check
     *
     * @return  true if the object implements the requested interface
     */
    bool ImplementsInterface(const char* iface) const { return GetInterface(iface) != NULL; }

    /**
     * Add an interface to this ProxyBusObject.
     *
     * Occasionally, AllJoyn library user may wish to call a method on
     * a %ProxyBusObject that was not reported during introspection of the remote object.
     * When this happens, the InterfaceDescription will have to be registered with the
     * Bus manually and the interface will have to be added to the %ProxyBusObject using this method.
     * @remark
     * The interface added via this call must have been previously registered with the
     * Bus. (i.e. it must have come from a call to Bus::GetInterface()).
     *
     * See also these sample file(s): @n
     * basic/basic_client.cc @n
     * basic/basic_service.cc @n
     * basic/signalConsumer_client.cc @n
     * basic/signal_service.cc @n
     * chat/android/jni/Chat_jni.cpp @n
     * chat/linux/chat.cc @n
     * FileTransfer/FileTransferClient.cc @n
     * FileTransfer/FileTransferService.cc @n
     * secure/DeskTopSharedKSClient.cc @n
     * secure/DeskTopSharedKSService.cc @n
     * simple/android/client/jni/Client_jni.cpp @n
     * windows/chat/ChatLib32/ChatClasses.cpp @n
     * windows/Client/Client.cpp @n
     * windows/PhotoChat/AllJoynBusLib/AllJoynConnection.cpp @n
     * windows/Service/Service.cpp @n
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/src/MediaSource.cc @n
     * cpp/Basic/Basic_Service/BasicService/AllJoynObjects.cpp @n
     * cpp/Basic/Signal_Service/SignalService/AllJoynObjects.cpp @n
     * cpp/Chat/Chat/AllJoynObjects.cpp @n
     * cpp/Secure/Secure/AllJoynObjects.cpp @n
     * csharp/Basic/Basic_Service/BasicService/Common/BasicServiceBusObject.cs @n
     * csharp/Basic/Signal_Service/SignalService/Common/SignalServiceBusObject.cs @n
     * csharp/BusStress/BusStress/Common/ServiceBusObject.cs @n
     * csharp/chat/chat/Common/ChatSessionObject.cs @n
     * csharp/FileTransfer/Client/Common/FileTransferBusObject.cs @n
     * csharp/Secure/Secure/Common/Client.cs @n
     * csharp/Secure/Secure/Common/SecureBusObject.cs @n
     * csharp/Sessions/Sessions/Common/MyBusObject.cs @n
     *
     * @param iface    The interface to add to this object. Must come from Bus::GetInterface().
     * @return
     *      - #ER_OK if successful.
     *      - An error status otherwise
     */
    QStatus AddInterface(const InterfaceDescription& iface);

    /**
     * Add an existing interface to this object using the interface's name.
     *
     * See also these sample file(s): @n
     * simple/android/client/jni/Client_jni.cpp @n
     *
     * @param name   Name of existing interface to add to this object.
     * @return
     *      - #ER_OK if successful.
     *      - An error status otherwise.
     */
    QStatus AddInterface(const char* name);

    /**
     * Returns an array of ProxyBusObjects for the children of this %ProxyBusObject.
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/src/MediaSink.cc @n
     *
     * @param children     A pointer to an %ProxyBusObject array to receive the children. Can be NULL in
     *                     which case no children are returned and the return value gives the number
     *                     of children available.
     * @param numChildren  The size of the %ProxyBusObject array. If this value is smaller than the total
     *                     number of children only numChildren will be returned.
     *
     * @return  The number of children returned or the total number of children if children is NULL.
     */
    size_t GetChildren(ProxyBusObject** children = NULL, size_t numChildren = 0);

    /**
     * Returns an array of _ProxyBusObjects for the children of this %ProxyBusObject.
     * Unlike the unmanaged version of GetChildren, it is expected the caller will call
     * delete on each _ProxyBusObject in the array returned.
     *
     * @param children     A pointer to a %_ProxyBusObject array to receive the children. Can be NULL in
     *                     which case no children are returned and the return value gives the number
     *                     of children available.
     * @param numChildren  The size of the %_ProxyBusObject array. If this value is smaller than the total
     *                     number of children only numChildren will be returned.
     *
     * @return  The number of children returned or the total number of children if children is NULL.
     */
    size_t GetManagedChildren(void* children = NULL, size_t numChildren = 0);

    /**
     * Get a path descendant ProxyBusObject (child) by its absolute or relative path name.
     *
     * For example, if this ProxyBusObject's path is @c "/foo/bar", then you can
     * retrieve the ProxyBusObject for @c "/foo/bar/bat/baz" by calling
     * @c GetChild("/foo/bar/bat/baz") or @c GetChild("bat/baz").
     *
     * @param path the absolute or relative path for the child.
     *
     * @return
     *      - The (potentially deep) descendant ProxyBusObject
     *      - NULL if not found.
     */
    ProxyBusObject* GetChild(const char* path);

    /**
     * Get a path descendant _ProxyBusObject (child) by its absolute or relative path name.
     *
     * For example, if this _ProxyBusObject's path is @c "/foo/bar", then you can retrieve the
     * _ProxyBusObject for @c "/foo/bar/bat/baz" by calling @c GetChild("/foo/bar/bat/baz") or
     * @c GetChild("bat/baz"). Unlike the unmanaged version of GetChild, it is expected the
     * caller will call delete on the _ProxyBusObject returned.
     *
     * @param inPath the absolute or relative path for the child.
     *
     * @return
     *      - The (potentially deep) descendant _ProxyBusObject
     *      - NULL if not found.
     */
    void* GetManagedChild(const char* inPath);

    /**
     * Add a child object (direct or deep object path descendant) to this object.
     * If you add a deep path descendant, this method will create intermediate
     * ProxyBusObject children as needed.
     *
     * @remark
     *  - It is an error to try to add a child that already exists.
     *  - It is an error to try to add a child that has an object path that is not a descendant of this object's path.
     *
     * @param child  Child ProxyBusObject
     * @return
     *      - #ER_OK if successful.
     *      - #ER_BUS_BAD_CHILD_PATH if the path is a bad path
     *      - #ER_BUS_OBJ_ALREADY_EXISTS the the object already exists on the ProxyBusObject
     */
    QStatus AddChild(const ProxyBusObject& child);

    /**
     * Remove a child object and any descendants it may have.
     *
     * @param path   Absolute or relative (to this ProxyBusObject) object path.
     * @return
     *      - #ER_OK if successful.
     *      - #ER_BUS_BAD_CHILD_PATH if the path given was not a valid path
     *      - #ER_BUS_OBJ_NOT_FOUND if the Child object was not found
     *      - #ER_FAIL any other unexpected error.
     */
    QStatus RemoveChild(const char* path);

    /**
     * Make a synchronous method call from this object
     *
     * @param method       Method being invoked.
     * @param args         The arguments for the method call (can be NULL)
     * @param numArgs      The number of arguments
     * @param replyMsg     The reply message received for the method call
     * @param timeout      Timeout specified in milliseconds to wait for a reply
     * @param flags        Logical OR of the message flags for this method call. The following flags apply to method calls:
     *                     - If #ALLJOYN_FLAG_ENCRYPTED is set the message is authenticated and the payload if any is encrypted.
     *                     - If #ALLJOYN_FLAG_COMPRESSED is set the header is compressed for destinations that can handle header compression.
     *                     - If #ALLJOYN_FLAG_AUTO_START is set the bus will attempt to start a service if it is not running.
     *
     *
     * @return
     *      - #ER_OK if the method call succeeded and the reply message type is #MESSAGE_METHOD_RET
     *      - #ER_BUS_REPLY_IS_ERROR_MESSAGE if the reply message type is #MESSAGE_ERROR
     */
    QStatus MethodCall(const InterfaceDescription::Member& method,
                       const MsgArg* args,
                       size_t numArgs,
                       Message& replyMsg,
                       uint32_t timeout = DefaultCallTimeout,
                       uint8_t flags = 0) const;

    /**
     * Make a synchronous method call from this object
     *
     * See also these sample file(s): @n
     * basic/basic_client.cc @n
     * chat/android/jni/Chat_jni.cpp @n
     * secure/DeskTopSharedKSClient.cc @n
     * simple/android/client/jni/Client_jni.cpp @n
     * windows/Client/Client.cpp @n
     * windows/PhotoChat/AllJoynBusLib/AllJoynBusLib.cpp @n
     *
     * @param ifaceName    Name of interface.
     * @param methodName   Name of method.
     * @param args         The arguments for the method call (can be NULL)
     * @param numArgs      The number of arguments
     * @param replyMsg     The reply message received for the method call
     * @param timeout      Timeout specified in milliseconds to wait for a reply
     * @param flags        Logical OR of the message flags for this method call. The following flags apply to method calls:
     *                     - If #ALLJOYN_FLAG_ENCRYPTED is set the message is authenticated and the payload if any is encrypted.
     *                     - If #ALLJOYN_FLAG_COMPRESSED is set the header is compressed for destinations that can handle header compression.
     *                     - If #ALLJOYN_FLAG_AUTO_START is set the bus will attempt to start a service if it is not running.
     *
     * @return
     *      - #ER_OK if the method call succeeded and the reply message type is #MESSAGE_METHOD_RET
     *      - #ER_BUS_REPLY_IS_ERROR_MESSAGE if the reply message type is #MESSAGE_ERROR
     */
    QStatus MethodCall(const char* ifaceName,
                       const char* methodName,
                       const MsgArg* args,
                       size_t numArgs,
                       Message& replyMsg,
                       uint32_t timeout = DefaultCallTimeout,
                       uint8_t flags = 0) const;

    /**
     * Make a fire-and-forget method call from this object. The caller will not be able to tell if
     * the method call was successful or not. This is equivalent to calling MethodCall() with
     * flags == ALLJOYN_FLAG_NO_REPLY_EXPECTED. Because this call doesn't block it can be made from
     * within a signal handler.
     *
     * @param ifaceName    Name of interface.
     * @param methodName   Name of method.
     * @param args         The arguments for the method call (can be NULL)
     * @param numArgs      The number of arguments
     * @param flags        Logical OR of the message flags for this method call. The following flags apply to method calls:
     *                     - If #ALLJOYN_FLAG_ENCRYPTED is set the message is authenticated and the payload if any is encrypted.
     *                     - If #ALLJOYN_FLAG_COMPRESSED is set the header is compressed for destinations that can handle header compression.
     *                     - If #ALLJOYN_FLAG_AUTO_START is set the bus will attempt to start a service if it is not running.
     *
     * @return
     *      - #ER_OK if the method call succeeded
     */
    QStatus MethodCall(const char* ifaceName,
                       const char* methodName,
                       const MsgArg* args,
                       size_t numArgs,
                       uint8_t flags = 0) const
    {
        return MethodCallAsync(ifaceName, methodName, NULL, NULL, args, numArgs, NULL, 0, flags |= ALLJOYN_FLAG_NO_REPLY_EXPECTED);
    }

    /**
     * Make a fire-and-forget method call from this object. The caller will not be able to tell if
     * the method call was successful or not. This is equivalent to calling MethodCall() with
     * flags == ALLJOYN_FLAG_NO_REPLY_EXPECTED. Because this call doesn't block it can be made from
     * within a signal handler.
     *
     * @param method       Method being invoked.
     * @param args         The arguments for the method call (can be NULL)
     * @param numArgs      The number of arguments
     * @param flags        Logical OR of the message flags for this method call. The following flags apply to method calls:
     *                     - If #ALLJOYN_FLAG_ENCRYPTED is set the message is authenticated and the payload if any is encrypted.
     *                     - If #ALLJOYN_FLAG_COMPRESSED is set the header is compressed for destinations that can handle header compression.
     *                     - If #ALLJOYN_FLAG_AUTO_START is set the bus will attempt to start a service if it is not running.
     *
     * @return
     *      - #ER_OK if the method call succeeded and the reply message type is #MESSAGE_METHOD_RET
     */
    QStatus MethodCall(const InterfaceDescription::Member& method,
                       const MsgArg* args,
                       size_t numArgs,
                       uint8_t flags = 0) const
    {
        return MethodCallAsync(method, NULL, NULL, args, numArgs, NULL, 0, flags |= ALLJOYN_FLAG_NO_REPLY_EXPECTED);
    }

    /**
     * Make an asynchronous method call from this object
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/src/MediaSink.cc @n
     * cpp/Basic/Basic_Client/BasicClient/MainPage.xaml.cpp @n
     * cpp/Secure/Secure/MainPage.xaml.cpp @n
     * csharp/Basic/Basic_Client/BasicClient/MainPage.xaml.cs @n
     * csharp/BusStress/BusStress/Common/StressOperation.cs @n
     *
     * @param method       Method being invoked.
     * @param receiver     The object to be called when the asych method call completes.
     * @param replyFunc    The function that is called to deliver the reply
     * @param args         The arguments for the method call (can be NULL)
     * @param numArgs      The number of arguments
     * @param receiver     The object to be called when the asych method call completes.
     * @param context      User-defined context that will be returned to the reply handler
     * @param timeout      Timeout specified in milliseconds to wait for a reply
     * @param flags        Logical OR of the message flags for this method call. The following flags apply to method calls:
     *                     - If #ALLJOYN_FLAG_ENCRYPTED is set the message is authenticated and the payload if any is encrypted.
     *                     - If #ALLJOYN_FLAG_COMPRESSED is set the header is compressed for destinations that can handle header compression.
     *                     - If #ALLJOYN_FLAG_AUTO_START is set the bus will attempt to start a service if it is not running.
     * @return
     *      - ER_OK if successful
     *      - An error status otherwise
     */
    QStatus MethodCallAsync(const InterfaceDescription::Member& method,
                            MessageReceiver* receiver,
                            MessageReceiver::ReplyHandler replyFunc,
                            const MsgArg* args = NULL,
                            size_t numArgs = 0,
                            void* context = NULL,
                            uint32_t timeout = DefaultCallTimeout,
                            uint8_t flags = 0) const;

    /**
     * Make an asynchronous method call from this object
     *
     * See also these sample file(s): @n
     * windows/Service/Service.cpp @n
     *
     * For Windows 8 see also these sample file(s): @n
     * csharp/Secure/Secure/Common/Client.cs @n
     *
     * @param ifaceName    Name of interface for method.
     * @param methodName   Name of method.
     * @param receiver     The object to be called when the asynchronous method call completes.
     * @param replyFunc    The function that is called to deliver the reply
     * @param args         The arguments for the method call (can be NULL)
     * @param numArgs      The number of arguments
     * @param context      User-defined context that will be returned to the reply handler
     * @param timeout      Timeout specified in milliseconds to wait for a reply
     * @param flags        Logical OR of the message flags for this method call. The following flags apply to method calls:
     *                     - If #ALLJOYN_FLAG_ENCRYPTED is set the message is authenticated and the payload if any is encrypted.
     *                     - If #ALLJOYN_FLAG_COMPRESSED is set the header is compressed for destinations that can handle header compression.
     *                     - If #ALLJOYN_FLAG_AUTO_START is set the bus will attempt to start a service if it is not running.
     * @return
     *      - ER_OK if successful
     *      - An error status otherwise
     */
    QStatus MethodCallAsync(const char* ifaceName,
                            const char* methodName,
                            MessageReceiver* receiver,
                            MessageReceiver::ReplyHandler replyFunc,
                            const MsgArg* args = NULL,
                            size_t numArgs = 0,
                            void* context = NULL,
                            uint32_t timeout = DefaultCallTimeout,
                            uint8_t flags = 0) const;

    /**
     * Initialize this proxy object from an XML string. Calling this method does several things:
     *
     *  -# Create and register any new InterfaceDescription(s) that are mentioned in the XML.
     *     (Interfaces that are already registered with the bus are left "as-is".)
     *  -# Add all the interfaces mentioned in the introspection data to this ProxyBusObject.
     *  -# Recursively create any child ProxyBusObject(s) and create/add their associated @n
     *     interfaces as mentioned in the XML. Then add the descendant object(s) to the appropriate
     *     descendant of this ProxyBusObject (in the children collection). If the named child object
     *     already exists as a child of the appropriate ProxyBusObject, then it is updated
     *     to include any new interfaces or children mentioned in the XML.
     *
     * Note that when this method fails during parsing, the return code will be set accordingly.
     * However, any interfaces which were successfully parsed prior to the failure
     * may be registered with the bus. Similarly, any objects that were successfully created
     * before the failure will exist in this object's set of children.
     *
     * @param xml         An XML string in DBus introspection format.
     * @param identifier  An optional identifying string to include in error logging messages.
     *
     * @return
     *      - #ER_OK if parsing is completely successful.
     *      - An error status otherwise.
     */
    QStatus ParseXml(const char* xml, const char* identifier = NULL);

    /**
     * Explicitly secure the connection to the remote peer for this proxy object. Peer-to-peer
     * connections can only be secured if EnablePeerSecurity() was previously called on the bus
     * attachment for this proxy object. If the peer-to-peer connection is already secure this
     * function does nothing. Note that peer-to-peer connections are automatically secured when a
     * method call requiring encryption is sent.
     *
     * This call causes messages to be send on the bus, therefore it cannot be called within AllJoyn
     * callbacks (method/signal/reply handlers or ObjectRegistered callbacks, etc.)
     *
     * @param forceAuth  If true, forces an re-authentication even if the peer connection is already
     *                   authenticated.
     *
     * @return
     *          - #ER_OK if the connection was secured or an error status indicating that the
     *            connection could not be secured.
     *          - #ER_BUS_NO_AUTHENTICATION_MECHANISM if BusAttachment::EnablePeerSecurity() has not been called.
     *          - #ER_AUTH_FAIL if the attempt(s) to authenticate the peer failed.
     *          - Other error status codes indicating a failure.
     */
    QStatus SecureConnection(bool forceAuth = false);

    /**
     * Asynchronously secure the connection to the remote peer for this proxy object. Peer-to-peer
     * connections can only be secured if EnablePeerSecurity() was previously called on the bus
     * attachment for this proxy object. If the peer-to-peer connection is already secure this
     * function does nothing. Note that peer-to-peer connections are automatically secured when a
     * method call requiring encryption is sent.
     *
     * Notification of success or failure is via the AuthListener passed to EnablePeerSecurity().
     *
     * @param forceAuth  If true, forces an re-authentication even if the peer connection is already
     *                   authenticated.
     *
     * @return
     *          - #ER_OK if securing could begin.
     *          - #ER_BUS_NO_AUTHENTICATION_MECHANISM if BusAttachment::EnablePeerSecurity() has not been called.
     *          - Other error status codes indicating a failure.
     */
    QStatus SecureConnectionAsync(bool forceAuth = false);

    /**
     * Assignment operator.
     *
     * @param other  The object being assigned from
     * @return a copy of the ProxyBusObject
     */
    ProxyBusObject& operator=(const ProxyBusObject& other);

    /**
     * Copy constructor
     *
     * @param other  The object being copied from.
     */
    ProxyBusObject(const ProxyBusObject& other);

    /**
     * Indicates if this is a valid (usable) proxy bus object.
     *
     * @return true if a valid proxy bus object, false otherwise.
     */
    bool IsValid() const { return bus != NULL; }

    /**
     * Indicates if the remote object for this proxy bus object is secure.
     *
     * @return  true if the object is secure
     */
    bool IsSecure() const { return isSecure; }

  private:

    /**
     * @internal
     * Method return handler used to process synchronous method calls.
     *
     * @param msg     Method return message
     * @param context Opaque context passed from method_call to method_return
     */
    void SyncReplyHandler(Message& msg, void* context);

    /**
     * @internal
     * Introspection method_reply handler. (Internal use only)
     */
    void IntrospectMethodCB(Message& message, void* context);

    /**
     * @internal
     * GetProperty method_reply handler. (Internal use only)
     */
    void GetPropMethodCB(Message& message, void* context);

    /**
     * @internal
     * GetAllProperties method_reply handler. (Internal use only)
     */
    void GetAllPropsMethodCB(Message& message, void* context);

    /**
     * @internal
     * SetProperty method_reply handler. (Internal use only)
     */
    void SetPropMethodCB(Message& message, void* context);

    /**
     * @internal
     * Set the B2B endpoint to use for all communication with remote object.
     * This method is for internal use only.
     */
    void SetB2BEndpoint(RemoteEndpoint& b2bEp);

    /**
     * @internal
     * Helper used to destruct and clean-up  ProxyBusObject::components member.
     */
    void DestructComponents();

    /**
     * @internal
     * Internal introspection xml parse tree type.
     */
    struct IntrospectionXml;

    /**
     * @internal
     * Parse a single introspection <node> element.
     *
     * @param parseNode  XML element (must be a <node>).
     *
     * @return
     *       - #ER_OK if completely successful.
     *       - An error status otherwise
     */
    static QStatus ParseNode(const IntrospectionXml& node);

    /**
     * @internal
     * Parse a single introspection <interface> element.
     *
     * @param parseNode  XML element (must be an <interface>).
     *
     * @return
     *       - #ER_OK if completely successful.
     *       - An error status otherwise
     */
    static QStatus ParseInterface(const IntrospectionXml& ifc);

    /** Bus associated with object */
    BusAttachment* bus;

    struct Components;
    Components* components;  /**< The subcomponents of this object */

    /** Object path of this object */
    qcc::String path;

    qcc::String serviceName;    /**< Remote destination */
    SessionId sessionId;        /**< Session to use for communicating with remote object */
    bool hasProperties;         /**< True if proxy object implements properties */
    mutable RemoteEndpoint b2bEp; /**< B2B endpoint to use or NULL to indicates normal sessionId based routing */
    mutable qcc::Mutex* lock;   /**< Lock that protects access to components member */
    bool isExiting;             /**< true iff ProxyBusObject is in the process of begin destroyed */
    bool isSecure;              /**< Indicates if this object is secure or not */
};

/**
 * _ProxyBusObject is a reference counted (managed) version of ProxyBusObject
 */
typedef qcc::ManagedObj<ProxyBusObject> _ProxyBusObject;

}

#endif
