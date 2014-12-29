#ifndef _ALLJOYN_INTERFACEDESCRIPTION_H
#define _ALLJOYN_INTERFACEDESCRIPTION_H
/**
 * @file
 * This file defines types for statically describing a message bus interface
 */

/******************************************************************************
 * Copyright (c) 2009-2011,2013, AllSeen Alliance. All rights reserved.
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
#include <alljoyn/DBusStd.h>
#include <alljoyn/Message.h>
#include <alljoyn/Status.h>
/// @cond ALLJOYN_DEV
/*!
   \def QCC_MODULE
   Internal usage
 */
#define QCC_MODULE "ALLJOYN"
/// @endcond

namespace ajn {

/** @name Access type */
// @{
static const uint8_t PROP_ACCESS_READ  = 1; /**< Read Access type */
static const uint8_t PROP_ACCESS_WRITE = 2; /**< Write Access type */
static const uint8_t PROP_ACCESS_RW    = 3; /**< Read-Write Access type */
// @}
/** @name Annotation flags */
// @{
static const uint8_t MEMBER_ANNOTATE_NO_REPLY   = 1; /**< No reply annotate flag */
static const uint8_t MEMBER_ANNOTATE_DEPRECATED = 2; /**< Deprecated annotate flag */
// @}

/**
 * The interface security policy can be inherit, required, or off. If security is
 * required on an interface, methods on that interface can only be called by an authenticated peer
 * and signals emitted from that interfaces can only be received by an authenticated peer. If
 * security is not specified for an interface the interface inherits the security of the objects
 * that implement it.  If security is not applicable to an interface authentication is never
 * required even when the implemented by a secure object. For example, security does not apply to
 * the Introspection interface otherwise secure objects would not be introspectable.
 */
typedef enum {
    AJ_IFC_SECURITY_INHERIT  = 0,   /**< Inherit the security of the object that implements the interface */
    AJ_IFC_SECURITY_REQUIRED = 1,   /**< Security is required for an interface */
    AJ_IFC_SECURITY_OFF      = 2    /**< Security does not apply to this interface */
} InterfaceSecurityPolicy;

/**
 * @class InterfaceDescription
 * Class for describing message bus interfaces. %InterfaceDescription objects describe the methods,
 * signals and properties of a BusObject or ProxyBusObject.
 *
 * Calling ProxyBusObject::AddInterface(const char*) adds the AllJoyn interface described by an
 * %InterfaceDescription to a ProxyBusObject instance. After an  %InterfaceDescription has been
 * added, the methods described in the interface can be called. Similarly calling
 * BusObject::AddInterface adds the interface and its methods, properties, and signal to a
 * BusObject. After an interface has been added method handlers for the methods described in the
 * interface can be added by calling BusObject::AddMethodHandler or BusObject::AddMethodHandlers.
 *
 * An %InterfaceDescription can be constructed piecemeal by calling InterfaceDescription::AddMethod,
 * InterfaceDescription::AddMember(), and InterfaceDescription::AddProperty(). Alternatively,
 * calling ProxyBusObject::ParseXml will create the %InterfaceDescription instances for that proxy
 * object directly from an XML string. Calling ProxyBusObject::IntrospectRemoteObject or
 * ProxyBusObject::IntrospectRemoteObjectAsync also creates the %InterfaceDescription
 * instances from XML but in this case the XML is obtained by making a remote Introspect method
 * call on a bus object.
 */

class InterfaceDescription {

    friend class BusAttachment;
    friend class XmlHelper;

  public:

    class AnnotationsMap; /**< A map to store string annotations */

    /**
     * Structure representing the member to be added to the Interface
     */
    struct Member {
        const InterfaceDescription* iface;   /**< Interface that this member belongs to */
        AllJoynMessageType memberType;          /**< %Member type */
        qcc::String name;                    /**< %Member name */
        qcc::String signature;               /**< Method call IN arguments (NULL for signals) */
        qcc::String returnSignature;         /**< Signal or method call OUT arguments */
        qcc::String argNames;                /**< Comma separated list of argument names - can be NULL */
        AnnotationsMap* annotations;           /**< Map of annotations */
        qcc::String accessPerms;              /**< Required permissions to invoke this call */

        /** %Member constructor.
         *
         * See also these sample file(s): @n
         * basic/basic_service.cc @n
         * basic/signalConsumer_client.cc @n
         * basic/signal_service.cc @n
         * chat/android/jni/Chat_jni.cpp @n
         * chat/linux/chat.cc @n
         * FileTransfer/FileTransferClient.cc @n
         * FileTransfer/FileTransferService.cc @n
         * secure/DeskTopSharedKSService.cc @n
         * simple/android/service/jni/Service_jni.cpp @n
         * windows/chat/ChatLib32/ChatClasses.cpp @n
         * windows/PhotoChat/AllJoynBusLib/AllJoynConnection.cpp @n
         * windows/Service/Service.cpp @n
         *
         * For Windows 8 see also these sample file(s): @n
         * cpp/AllJoynStreaming/src/MediaSink.cc @n
         * cpp/AllJoynStreaming/src/MediaSource.cc @n
         * cpp/Basic/Basic_Client/BasicClient/MainPage.xaml.cpp @n
         * cpp/Basic/Basic_Service/BasicService/AllJoynObjects.cpp @n
         * cpp/Chat/Chat/AllJoynObjects.cpp @n
         * cpp/Secure/Secure/AllJoynObjects.cpp @n
         * cpp/Secure/Secure/MainPage.xaml.cpp @n
         * csharp/Basic/Basic_Client/BasicClient/MainPage.xaml.cs @n
         * csharp/Basic/Basic_Service/BasicService/Common/BasicServiceBusObject.cs @n
         * csharp/chat/chat/Common/ChatSessionObject.cs @n
         * csharp/Secure/Secure/Common/SecureBusObject.cs @n
         * javascript/Basic/Basic_Client/BasicClient/js/AlljoynObjects.js @n
         * javascript/Basic/Basic_Service/BasicService/js/AlljoynObjects.js @n
         * javascript/Basic/Basic_Service/BasicService/js/script1.js @n
         * javascript/Basic/Signal_Service/SignalService/js/AlljoynObjects.js @n
         * javascript/chat/chat/js/alljoyn.js @n
         * javascript/Secure/Secure/js/Client.js @n
         * javascript/Secure/Secure/js/Service.js @n
         *
         * @param iface The interface this member is added to.
         * @param type The message type.
         * @param name The name of this member.
         * @param signature The signature of this member. May be NULL.
         * @param returnSignature The return signature of this member. May be NULL.
         * @param argNames The name of the arguments. May be NULL.
         * @param annotation Ignored.
         * @param accessPerms The permissions of this member.
         */
        Member(const InterfaceDescription* iface, AllJoynMessageType type, const char* name,
               const char* signature, const char* returnSignature, const char* argNames,
               uint8_t annotation, const char* accessPerms);

        /**
         * %Member copy constructor
         * @param other  The %Member being copied to this one.
         */
        Member(const Member& other);

        /**
         * %Member assignment operator
         * @param other  The %Member being copied to this one.
         *
         * @return
         * a reference to the %Member that was just copied
         */
        Member& operator=(const Member& other);

        /** %Member destructor */
        ~Member();

        /**
         * Get the names and values of all annotations
         *
         * @param[out] names    Annotation names
         * @param[out] values    Annotation values
         * @param      size     Number of annotations to get
         * @return              The number of annotations returned or the total number of annotations if props is NULL.
         */
        size_t GetAnnotations(qcc::String* names = NULL, qcc::String* values = NULL, size_t size = 0) const;

        /**
         * Get this member's annotation value
         * @param name   name of the annotation to look for
         * @param[out]   value  The value of the annotation, if found
         * @return    true iff annotations[name] == value
         */
        bool GetAnnotation(const qcc::String& name, qcc::String& value) const;

        /**
         * Equality. Two members are defined to be equal if their members are equal except for iface which is ignored for equality.
         * @param o   Member to compare against this member.
         * @return    true iff o == this member.
         */
        bool operator==(const Member& o) const;
    };

    /**
     * Structure representing properties of the Interface
     */
    struct Property {
        qcc::String name;              /**< %Property name */
        qcc::String signature;         /**< %Property type */
        uint8_t access;                /**< Access is #PROP_ACCESS_READ, #PROP_ACCESS_WRITE, or #PROP_ACCESS_RW */
        AnnotationsMap* annotations;    /**< Map of annotations */

        /** %Property constructor.
         * @param name      The name of the property.
         * @param signature The signature of the property. May be NULL.
         * @param access    The access type, may be #PROP_ACCESS_READ, #PROP_ACCESS_WRITE, or #PROP_ACCESS_RW.
         */
        Property(const char* name, const char* signature, uint8_t access);

        /**
         * %Property copy constructor
         * @param other  The %Property being copied to this one.
         */
        Property(const Property& other);

        /**
         * %Property assignment operator
         * @param other  The %Property being copied to this one.
         * @return       A reference to the %Property that was just copied
         */
        Property& operator=(const Property& other);

        /** %Property destructor */
        ~Property();

        /**
         * Get the names and values of all annotations
         *
         * @param[out] names    Annotation names
         * @param[out] values   Annotation values
         * @param      size     Number of annotations to get
         * @return              The number of annotations returned or the total number of annotations if props is NULL.
         */
        size_t GetAnnotations(qcc::String* names = NULL, qcc::String* values = NULL, size_t size = 0) const;

        /**
         * Get this property's annotation value
         * @param name   name of the annotation to look for
         * @param[out]   value  The value of the annotation, if found
         * @return    true iff annotations[name] == value
         */
        bool GetAnnotation(const qcc::String& name, qcc::String& value) const;

        /** Equality */
        bool operator==(const Property& o) const;
    };

    /**
     * Add a member to the interface.
     *
     * @param type        Message type.
     * @param name        Name of member.
     * @param inputSig    Signature of input parameters or NULL for none.
     * @param outSig      Signature of output parameters or NULL for none.
     * @param argNames    Comma separated list of input and then output arg names used in annotation XML.
     * @param annotation  Annotation flags.
     * @param accessPerms Required permissions to invoke this call
     *
     * @return
     *      - #ER_OK if successful
     *      - #ER_BUS_MEMBER_ALREADY_EXISTS if member already exists
     */
    QStatus AddMember(AllJoynMessageType type, const char* name, const char* inputSig, const char* outSig, const char* argNames, uint8_t annotation = 0, const char* accessPerms = 0);

    /**
     * Lookup a member description by name
     *
     * See also these sample file(s): @n
     * basic/basic_service.cc @n
     * basic/signalConsumer_client.cc @n
     * basic/signal_service.cc @n
     * chat/android/jni/Chat_jni.cpp @n
     * chat/linux/chat.cc @n
     * FileTransfer/FileTransferClient.cc @n
     * FileTransfer/FileTransferService.cc @n
     * secure/DeskTopSharedKSService.cc @n
     * simple/android/service/jni/Service_jni.cpp @n
     * windows/chat/ChatLib32/ChatClasses.cpp @n
     * windows/PhotoChat/AllJoynBusLib/AllJoynConnection.cpp @n
     * windows/Service/Service.cpp @n
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/src/MediaSink.cc @n
     * cpp/AllJoynStreaming/src/MediaSource.cc @n
     * cpp/Basic/Basic_Client/BasicClient/Generated @n
     * cpp/Basic/Basic_Client/BasicClient/MainPage.xaml.cpp @n
     * cpp/Basic/Basic_Service/BasicService/AllJoynObjects.cpp @n
     * cpp/Basic/Basic_Service/BasicService/Generated @n
     * cpp/Basic/Name_Change_Client/NameChangeClient/Generated @n
     * cpp/Basic/Signal_Consumer_Client/SignalConsumerClient/Generated @n
     * cpp/Basic/Signal_Service/SignalService/Generated @n
     * cpp/Secure/Secure/AllJoynObjects.cpp @n
     * cpp/Secure/Secure/MainPage.xaml.cpp @n
     * csharp/Basic/Basic_Client/BasicClient/MainPage.xaml.cs @n
     * csharp/Basic/Basic_Service/BasicService/Common/BasicServiceBusObject.cs @n
     * csharp/chat/chat/Common/ChatSessionObject.cs @n
     * csharp/Secure/Secure/Common/SecureBusObject.cs @n
     *
     * @param name  Name of the member to lookup
     * @return
     *      - Pointer to member.
     *      - NULL if does not exist.
     */
    const Member* GetMember(const char* name) const;

    /**
     * Get all the members.
     *
     * @param members     A pointer to a Member array to receive the members. Can be NULL in
     *                    which case no members are returned and the return value gives the number
     *                    of members available.
     * @param numMembers  The size of the Member array. If this value is smaller than the total
     *                    number of members only numMembers will be returned.
     *
     * @return  The number of members returned or the total number of members if members is NULL.
     */
    size_t GetMembers(const Member** members = NULL, size_t numMembers = 0) const;

    /**
     * Check for existence of a member. Optionally check the signature also.
     * @remark
     * if the a signature is not provided this method will only check to see if
     * a member with the given @c name exists.  If a signature is provided a
     * member with the given @c name and @c signature must exist for this to return true.
     *
     * @param name       Name of the member to lookup
     * @param inSig      Input parameter signature of the member to lookup
     * @param outSig     Output parameter signature of the member to lookup (leave NULL for signals)
     * @return true if the member name exists.
     */
    bool HasMember(const char* name, const char* inSig = NULL, const char* outSig = NULL);

    /**
     * Add a method call member to the interface.
     *
     * See also these sample file(s): @n
     * basic/basic_client.cc @n
     * basic/basic_service.cc @n
     * secure/DeskTopSharedKSClient.cc @n
     * secure/DeskTopSharedKSService.cc @n
     * simple/android/client/jni/Client_jni.cpp @n
     * simple/android/service/jni/Service_jni.cpp @n
     * windows/Client/Client.cpp @n
     * windows/PhotoChat/AllJoynBusLib/AllJoynConnection.cpp @n
     * windows/Service/Service.cpp @n
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/Basic/Basic_Service/BasicService/MainPage.xaml.cpp @n
     * cpp/Secure/Secure/AllJoynObjects.cpp @n
     * csharp/Basic/Basic_Service/BasicService/Common/BasicServiceBusObject.cs @n
     * csharp/BusStress/BusStress/Common/ServiceBusObject.cs @n
     * csharp/Secure/Secure/Common/Client.cs @n
     * csharp/Secure/Secure/Common/Service.cs @n
     *
     * @param name        Name of method call member.
     * @param inputSig    Signature of input parameters or NULL for none.
     * @param outSig      Signature of output parameters or NULL for none.
     * @param argNames    Comma separated list of input and then output arg names used in annotation XML.
     * @param annotation  Annotation flags.
     * @param accessPerms Access permission requirements on this call
     *
     * @return
     *      - #ER_OK if successful
     *      - #ER_BUS_MEMBER_ALREADY_EXISTS if member already exists
     */
    QStatus AddMethod(const char* name, const char* inputSig, const char* outSig, const char* argNames, uint8_t annotation = 0, const char* accessPerms = 0)
    {
        return AddMember(MESSAGE_METHOD_CALL, name, inputSig, outSig, argNames, annotation, accessPerms);
    }

    /**
     * Add an annotation to an existing member (signal or method).
     *
     * @param member     Name of member
     * @param name       Name of annotation
     * @param value      Value for the annotation
     *
     * @return
     *      - #ER_OK if successful
     *      - #ER_BUS_MEMBER_ALREADY_EXISTS if member already exists
     */
    QStatus AddMemberAnnotation(const char* member, const qcc::String& name, const qcc::String& value);

    /**
     * Get annotation to an existing member (signal or method).
     *
     * @param member     Name of member
     * @param name       Name of annotation
     * @param value      Output value for the annotation
     *
     * @return
     *      - true if found
     *      - false if property not found
     */
    bool GetMemberAnnotation(const char* member, const qcc::String& name, qcc::String& value) const;

    /**
     * Lookup a member method description by name
     *
     * For Windows 8 see also these sample file(s): @n
     * csharp/BusStress/BusStress/Common/ServiceBusObject.cs @n
     * csharp/BusStress/BusStress/Common/StressOperation.cs @n
     *
     * @param name  Name of the method to lookup
     * @return
     *      - Pointer to member.
     *      - NULL if does not exist.
     */
    const Member* GetMethod(const char* name) const
    {
        const Member* method = GetMember(name);
        return (method && method->memberType == MESSAGE_METHOD_CALL) ? method : NULL;
    }

    /**
     * Add a signal member to the interface.
     *
     * See also these sample file(s): @n
     * basic/signalConsumer_client.cc @n
     * basic/signal_service.cc @n
     * chat/android/jni/Chat_jni.cpp @n
     * chat/linux/chat.cc @n
     * FileTransfer/FileTransferClient.cc @n
     * FileTransfer/FileTransferService.cc @n
     * windows/chat/ChatLib32/ChatClasses.cpp @n
     * windows/PhotoChat/AllJoynBusLib/AllJoynConnection.cpp @n
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/Basic/Signal_Consumer_Client/SignalConsumerClient/MainPage.xaml.cpp @n
     * cpp/Basic/Signal_Service/SignalService/MainPage.xaml.cpp @n
     * cpp/Chat/Chat/AllJoynObjects.cpp @n
     * csharp/Basic/Signal_Consumer_Client/SignalConsumerClient/MainPage.xaml.cs @n
     * csharp/Basic/Signal_Service/SignalService/Common/SignalServiceBusObject.cs @n
     * csharp/chat/chat/Common/ChatSessionObject.cs @n
     * csharp/FileTransfer/Client/Common/FileTransferBusObject.cs @n
     * csharp/Sessions/Sessions/Common/MyBusObject.cs @n
     *
     * @param name        Name of method call member.
     * @param sig         Signature of parameters or NULL for none.
     * @param argNames    Comma separated list of arg names used in annotation XML.
     * @param annotation  Annotation flags.
     * @param accessPerms Access permission requirements on this call
     *
     * @return
     *      - #ER_OK if successful
     *      - #ER_BUS_MEMBER_ALREADY_EXISTS if member already exists
     */
    QStatus AddSignal(const char* name, const char* sig, const char* argNames, uint8_t annotation = 0, const char* accessPerms = 0)
    {
        return AddMember(MESSAGE_SIGNAL, name, sig, NULL, argNames, annotation, accessPerms);
    }

    /**
     * Lookup a member signal description by name
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/Basic/Signal_Consumer_Client/SignalConsumerClient/AllJoynObjects.cpp @n
     * cpp/Basic/Signal_Service/SignalService/AllJoynObjects.cpp @n
     * cpp/Chat/Chat/AllJoynObjects.cpp @n
     * csharp/Basic/Signal_Consumer_Client/SignalConsumerClient/Common/SignalConsumerBusListener.cs @n
     * csharp/Basic/Signal_Service/SignalService/Common/SignalServiceBusObject.cs @n
     * csharp/FileTransfer/Client/Common/FileTransferBusObject.cs @n
     * csharp/Sessions/Sessions/Common/MyBusObject.cs @n
     *
     * @param name  Name of the signal to lookup
     * @return
     *      - Pointer to member.
     *      - NULL if does not exist.
     */
    const Member* GetSignal(const char* name) const
    {
        const Member* method = GetMember(name);
        return (method && method->memberType == MESSAGE_SIGNAL) ? method : NULL;
    }

    /**
     * Lookup a property description by name
     *
     * @param name  Name of the property to lookup
     * @return a structure representing the properties of the interface
     */
    const Property* GetProperty(const char* name) const;

    /**
     * Get all the properties.
     *
     * @param props     A pointer to a Property array to receive the properties. Can be NULL in
     *                  which case no properties are returned and the return value gives the number
     *                  of properties available.
     * @param numProps  The size of the Property array. If this value is smaller than the total
     *                  number of properties only numProperties will be returned.
     *
     *
     * @return  The number of properties returned or the total number of properties if props is NULL.
     */
    size_t GetProperties(const Property** props = NULL, size_t numProps = 0) const;

    /**
     * Add a property to the interface.
     *
     * See also these sample file(s): @n
     * basic/signalConsumer_client.cc @n
     * basic/signal_service.cc @n
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/Basic/Signal_Consumer_Client/SignalConsumerClient/MainPage.xaml.cpp @n
     * cpp/Basic/Signal_Service/SignalService/MainPage.xaml.cpp @n
     * csharp/Basic/Signal_Consumer_Client/SignalConsumerClient/MainPage.xaml.cs @n
     * csharp/Basic/Signal_Service/SignalService/Common/SignalServiceBusObject.cs @n
     *
     * @param name       Name of property.
     * @param signature  Property type.
     * @param access     #PROP_ACCESS_READ, #PROP_ACCESS_WRITE or #PROP_ACCESS_RW
     * @return
     *      - #ER_OK if successful.
     *      - #ER_BUS_PROPERTY_ALREADY_EXISTS if the property can not be added
     *                                        because it already exists.
     */
    QStatus AddProperty(const char* name, const char* signature, uint8_t access);

    /**
     * Add an annotation to an existing property
     * @param p_name     Name of the property
     * @param name       Name of annotation
     * @param value      Value for the annotation
     * @return
     *      - #ER_OK if successful.
     *      - #ER_BUS_PROPERTY_ALREADY_EXISTS if the annotation can not be added to the property because it already exists.
     */
    QStatus AddPropertyAnnotation(const qcc::String& p_name, const qcc::String& name, const qcc::String& value);

    /**
     * Get the annotation value for a property
     * @param p_name     Name of the property
     * @param name       Name of annotation
     * @param value      Value for the annotation
     * @return           true if found, false if not found
     */
    bool GetPropertyAnnotation(const qcc::String& p_name, const qcc::String& name, qcc::String& value) const;

    /**
     * Check for existence of a property.
     *
     * @param name       Name of the property to lookup
     * @return true if the property exists.
     */
    bool HasProperty(const char* name) const { return GetProperty(name) != NULL; }

    /**
     * Check for existence of any properties
     *
     * @return  true if interface has any properties.
     */
    bool HasProperties() const { return GetProperties() != 0; }

    /**
     * Returns the name of the interface
     *
     * @return the interface name.
     */
    const char* GetName() const { return name.c_str(); }

    /**
     * Add an annotation to the interface.
     *
     * @param name       Name of annotation.
     * @param value      Value of the annotation
     * @return
     *      - #ER_OK if successful.
     *      - #ER_BUS_PROPERTY_ALREADY_EXISTS if the property can not be added
     *                                        because it already exists.
     */
    QStatus AddAnnotation(const qcc::String& name, const qcc::String& value);

    /**
     * Get the value of an annotation
     *
     * @param name       Name of annotation.
     * @param value      Returned value of the annotation
     * @return
     *      - true if annotation found.
     *      - false if annotation not found
     */
    bool GetAnnotation(const qcc::String& name, qcc::String& value) const;

    /**
     * Get the names and values of all annotations
     *
     * @param[out] names    Annotation names
     * @param[out] values    Annotation values
     * @param[out] size     Number of annotations
     * @return              The number of annotations returned or the total number of annotations if props is NULL.
     */
    size_t GetAnnotations(qcc::String* names = NULL, qcc::String* values = NULL, size_t size = 0) const;

    /**
     * Returns a description of the interface in introspection XML format
     * @return The interface description in introspection XML format.
     *
     * @param indent   Number of space chars to use in XML indentation.
     * @return The XML introspection data.
     */
    qcc::String Introspect(size_t indent = 0) const;

    /**
     * Activate this interface. An interface must be activated before it can be used. Activating an
     * interface locks the interface so that is can no longer be modified.
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
     * simple/android/service/jni/Service_jni.cpp @n
     * windows/chat/ChatLib32/ChatClasses.cpp @n
     * windows/Client/Client.cpp @n
     * windows/PhotoChat/AllJoynBusLib/AllJoynConnection.cpp @n
     * windows/Service/Service.cpp @n
     *
     * For Windows 8 see also these sample file(s): @n
     * cpp/AllJoynStreaming/tests/csharp/MediaPlayerApp/App.xaml.cs @n
     * cpp/AllJoynStreaming/tests/csharp/MediaServerApp/App.xaml.cs @n
     * cpp/Basic/Basic_Client/BasicClient/App.xaml.cpp @n
     * cpp/Basic/Basic_Service/BasicService/App.xaml.cpp @n
     * cpp/Basic/Basic_Service/BasicService/MainPage.xaml.cpp @n
     * cpp/Basic/Name_Change_Client/NameChangeClient/App.xaml.cpp @n
     * cpp/Basic/Signal_Consumer_Client/SignalConsumerClient/App.xaml.cpp @n
     * cpp/Basic/Signal_Consumer_Client/SignalConsumerClient/MainPage.xaml.cpp @n
     * cpp/Basic/Signal_Service/SignalService/App.xaml.cpp @n
     * cpp/Basic/Signal_Service/SignalService/MainPage.xaml.cpp @n
     * cpp/Chat/Chat/AllJoynObjects.cpp @n
     * cpp/Chat/Chat/App.xaml.cpp @n
     * cpp/Secure/Secure/AllJoynObjects.cpp @n
     * cpp/Secure/Secure/App.xaml.cpp @n
     * csharp/Basic/Basic_Client/BasicClient/App.xaml.cs @n
     * csharp/Basic/Basic_Service/BasicService/App.xaml.cs @n
     * csharp/Basic/Basic_Service/BasicService/Common/BasicServiceBusObject.cs @n
     * csharp/Basic/Name_Change_Client/NameChangeClient/App.xaml.cs @n
     * csharp/Basic/Signal_Consumer_Client/SignalConsumerClient/App.xaml.cs @n
     * csharp/Basic/Signal_Consumer_Client/SignalConsumerClient/MainPage.xaml.cs @n
     * csharp/Basic/Signal_Service/SignalService/App.xaml.cs @n
     * csharp/Basic/Signal_Service/SignalService/Common/SignalServiceBusObject.cs @n
     * csharp/blank/blank/App.xaml.cs @n
     * csharp/BusStress/BusStress/App.xaml.cs @n
     * csharp/BusStress/BusStress/Common/ServiceBusObject.cs @n
     * csharp/chat/chat/App.xaml.cs @n
     * csharp/chat/chat/Common/ChatSessionObject.cs @n
     * csharp/FileTransfer/Client/App.xaml.cs @n
     * csharp/FileTransfer/Client/Common/FileTransferBusObject.cs @n
     * csharp/Secure/Secure/App.xaml.cs @n
     * csharp/Secure/Secure/Common/Client.cs @n
     * csharp/Secure/Secure/Common/Service.cs @n
     * csharp/Sessions/Sessions/App.xaml.cs @n
     * csharp/Sessions/Sessions/Common/MyBusObject.cs @n
     */
    void Activate() { isActivated = true; }

    /**
     * Indicates if this interface is required to be secure. Secure interfaces require end-to-end
     * authentication.  The arguments for methods calls made to secure interfaces and signals
     * emitted by secure interfaces are encrypted.
     *
     * @return true if the interface is required to be secure.
     */
    bool IsSecure() const { return secPolicy == AJ_IFC_SECURITY_REQUIRED; }

    /**
     * Get the security policy that applies to this interface.
     *
     * @return Returns the security policy for this interface.
     */
    InterfaceSecurityPolicy GetSecurityPolicy() const { return secPolicy; }

    /**
     * Equality operation.
     */
    bool operator==(const InterfaceDescription& other) const;

    /**
     * Destructor
     */
    ~InterfaceDescription();

    /**
     * Copy constructor
     *
     * @param other  The InterfaceDescription being copied to this one.
     */
    InterfaceDescription(const InterfaceDescription& other);

  private:

    /**
     * Default constructor is private
     */
    InterfaceDescription() { }

    /**
     * Construct an interface with no methods or properties
     * This constructor cannot be used by any class other than the factory class (Bus).
     *
     * @param name      Fully qualified interface name.
     * @param secPolicy The security policy for this interface
     */
    InterfaceDescription(const char* name, InterfaceSecurityPolicy secPolicy);

    /**
     * Assignment operator
     *
     * @param other  The InterfaceDescription being copied to this one.
     */
    InterfaceDescription& operator=(const InterfaceDescription& other);

    struct Definitions;
    Definitions* defs;   /**< The definitions for this interface */

    qcc::String name;    /**< Name of interface */
    bool isActivated;    /**< Set to true when interface is activated */
    InterfaceSecurityPolicy secPolicy; /**< The security policy for this interface */

};

}

#undef QCC_MODULE
#endif
