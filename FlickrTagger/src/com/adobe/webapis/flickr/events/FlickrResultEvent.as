/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.adobe.webapis.flickr.events {

	import com.adobe.webapis.events.ServiceEvent;
	
	/**
	* Event class that contains information about events broadcast in response
	* to data events from the Flickr API.
	*
	* @author Darron Schall
	*/
	public class FlickrResultEvent extends ServiceEvent
	{
		/** Constant for the authCheckToken event type. */
		public static const AUTH_CHECK_TOKEN:String = "authCheckToken";
		
		/** Constant for the authGetFrob event type. */
		public static const AUTH_GET_FROB:String = "authGetFrob";
		
		/** Constant for the authGetToken event type. */
		public static const AUTH_GET_TOKEN:String = "authGetToken";
		
		/** Constant for the blogsGetList event type. */
		public static const BLOGS_GET_LIST:String = "blogsGetList";
		
		/** Constant for the blogsPostPhoto event type. */
		public static const BLOGS_POST_PHOTO:String = "blogsPostPhoto";
		
		/** Constant for the contactsGetList event type. */
		public static const CONTACTS_GET_LIST:String = "contactsGetList";
		
		/** Constant for the contactsGetPublicList event type. */
		public static const CONTACTS_GET_PUBLIC_LIST:String = "contactsGetPublicList";
		
		/** Constant for the favoritesAdd event type. */
		public static const FAVORITES_ADD:String = "favoritesAdd";

		/** Constant for the favoritesGetList event type. */
		public static const FAVORITES_GET_LIST:String = "favoritesGetList";
		
		/** Constant for the favoritesGetPublicList event type. */
		public static const FAVORITES_GET_PUBLIC_LIST:String = "favoritesGetPublicList";
		
		/** Constant for the favoritesRemove event type. */
		public static const FAVORITES_REMOVE:String = "favoritesRemove";
		
		/** Constant for the groupsBrowse event type. */
		public static const GROUPS_BROWSE:String = "groupsBrowse";
		
		/** Constant for the groupsGetInfo event type. */
		public static const GROUPS_GET_INFO:String = "groupsGetInfo";
		
		/** Constant for the groupsSearch event type. */
		public static const GROUPS_SEARCH:String = "groupsSearch";
		
		/** Constant for the groupsPoolsAdd event type. */
		public static const GROUPS_POOLS_ADD:String = "groupsPoolsAdd";
		
		/** Constant for the groupsPoolsGetContext event type. */
		public static const GROUPS_POOLS_GET_CONTEXT:String = "groupsPoolsGetContext";
		
		/** Constant for the groupsPoolsGetGroups event type. */
		public static const GROUPS_POOLS_GET_GROUPS:String = "groupsPoolsGetGroups";
		
		/** Constant for the groupsPoolsGetPhotos event type. */
		public static const GROUPS_POOLS_GET_PHOTOS:String = "groupsPoolsGetPhotos";
		
		/** Constant for the groupsPoolRemove event type. */
		public static const GROUPS_POOLS_REMOVE:String = "groupsPoolsRemove";
		
		/** Constant for the interestingnessGetList event type. */
		public static const INTERESTINGNESS_GET_LIST:String = "interestingnessGetList";
		
		/** Constant for the peopleFindByEmail event type. */
		public static const PEOPLE_FIND_BY_EMAIL:String = "peopleFindByEmail";
		
		/** Constant for the peopleFindByUsername event type. */
		public static const PEOPLE_FIND_BY_USERNAME:String = "peopleFindByUsername";
		
		/** Constant for the peopleGetInfo event type. */
		public static const PEOPLE_GET_INFO:String = "peopleGetInfo";
		
		/** Constant for the peopleGetPublicGroups event type. */
		public static const PEOPLE_GET_PUBLIC_GROUPS:String = "peopleGetPublicGroups";
		
		/** Constant for the peopleetPublicPhotos event type. */
		public static const PEOPLE_GET_PUBLIC_PHOTOS:String = "peopleGetPublicPhotos";
		
		/** Constant for the peopleGetUploadStatus event type. */
		public static const PEOPLE_GET_UPLOAD_STATUS:String = "peopleGetUploadStatus";
		
		/** Constant for the photosAddTags event type. */
		public static const PHOTOS_ADD_TAGS:String = "photosAddTags";
		
		/** Constant for the photosGetAllContexts event type. */
		public static const PHOTOS_GET_ALL_CONTEXTS:String = "photosGetAllContexts";
		
		/** Constant for the photosGetContactsPhotos event type. */
		public static const PHOTOS_GET_CONTACTS_PHOTOS:String = "photosGetContactsPhotos";
		
		/** Constant for the photosGetContactsPublicPhotos event type. */
		public static const PHOTOS_GET_CONTACTS_PUBLIC_PHOTOS:String = "photosGetContactsPublicPhotos";
		
		/** Constant for the photosGetContext event type. */
		public static const PHOTOS_GET_CONTEXT:String = "photosGetContext";
		
		/** Constant for the photosGetCounts event type. */
		public static const PHOTOS_GET_COUNTS:String = "photosGetCounts";
		
		/** Constant for the photosGetExif event type. */
		public static const PHOTOS_GET_EXIF:String = "photosGetExif";

		/** Constant for the photosGetInfo event type. */
		public static const PHOTOS_GET_INFO:String = "photosGetInfo";
		
		/** Constant for the photosGetNotInSet event type. */
		public static const PHOTOS_GET_NOT_IN_SET:String = "photosGetNotInSet";
		
		/** Constant for the photosGetPerms event type. */
		public static const PHOTOS_GET_PERMS:String = "photosGetPerms";
		
		/** Constant for the photosGetRecent event type. */
		public static const PHOTOS_GET_RECENT:String = "photosGetRecent";
		
		/** Constant for the photosGetSizes event type. */
		public static const PHOTOS_GET_SIZES:String = "photosGetSizes";
		
		/** Constant for the photosGetUntagged event type. */
		public static const PHOTOS_GET_UNTAGGED:String = "photosGetUntagged";
		
		/** Constant for the photosRemoveTag event type. */
		public static const PHOTOS_REMOVE_TAG:String = "photosRemoveTag";
		
		/** Constant for the photosSearch event type. */
		public static const PHOTOS_SEARCH:String = "photosSearch";
		
		/** Constant for the photosSetDates event type. */
		public static const PHOTOS_SET_DATES:String = "photosSetDates";
		
		/** Constant for the photosSetMeta event type. */
		public static const PHOTOS_SET_META:String = "photosSetMeta";
		
		/** Constant for the photosSetPerms event type. */
		public static const PHOTOS_SET_PERMS:String = "photosSetPerms";
		
		/** Constant for the photosSetTags event type. */
		public static const PHOTOS_SET_TAGS:String = "photosSetTags";
		
		/** Constant for the photosLicensesGetInfo event type. */
		public static const PHOTOS_LICENSES_GET_INFO:String = "photosLicensesGetInfo";
		
		/** Constant for the photosLicensesSetLicense event type. */
		public static const PHOTOS_LICENSES_SET_LICENSE:String = "photosLicensesSetLicense";
		
		/** Constant for the photosNotesAdd event type. */
		public static const PHOTOS_NOTES_ADD:String = "photosNotesAdd";
		
		/** Constant for the photosNotesEdit event type. */
		public static const PHOTOS_NOTES_EDIT:String = "photosNotesEdit";
		
		/** Constant for the photosNotesDelete event type. */
		public static const PHOTOS_NOTES_DELETE:String = "photosNotesDelete";
		
		/** Constant for the photosTransformRotate event type. */
		public static const PHOTOS_TRANSFORM_ROTATE:String = "photosTransformRotate";
		
		/** Constant for the photosUploadCheckTickets event type. */
		public static const PHOTOS_UPLOAD_CHECK_TICKETS:String = "photosUploadCheckTickets";
		
		/** Constant for the photosetsAddPhoto event type. */
		public static const PHOTOSETS_ADD_PHOTO:String = "photosetsAddPhoto";
		
		/** Constant for the photosetsCreate event type. */
		public static const PHOTOSETS_CREATE:String = "photosetsCreate";
		
		/** Constant for the photosetsDelete event type. */
		public static const PHOTOSETS_DELETE:String = "photosetsDelete";
		
		/** Constant for the photosetsEditMeta event type. */
		public static const PHOTOSETS_EDIT_META:String = "photosetsEditMeta";
		
		/** Constant for the photosetsEditPhotos event type. */
		public static const PHOTOSETS_EDIT_PHOTOS:String = "photosetsEditPhotos";
		
		/** Constant for the photosetsGetContext event type. */
		public static const PHOTOSETS_GET_CONTEXT:String = "photosetsGetContext";
		
		/** Constant for the photosetsGetInfo event type. */
		public static const PHOTOSETS_GET_INFO:String = "photosetsGetInfo";
		
		/** Constant for the photosetsGetList event type. */
		public static const PHOTOSETS_GET_LIST:String = "photosetsGetList";
		
		/** Constant for the photosetsGetPhotos event type. */
		public static const PHOTOSETS_GET_PHOTOS:String = "photosetsGetPhotos";
		
		/** Constant for the photosets event type. */
		public static const PHOTOSETS_ORDER_SETS:String = "photosetsOrderSets";
		
		/** Constant for the photosets event type. */
		public static const PHOTOSETS_REMOVE_PHOTO:String = "photosetsRemovePhoto";
		
		/** Constant for the tagsGetListPhoto event type. */
		public static const TAGS_GET_LIST_PHOTO:String = "tagsGetListPhoto";
		
		/** Constant for the tagsGetListUser event type. */
		public static const TAGS_GET_LIST_USER:String = "tagsGetListUser";
		
		/** Constant for the tagsGetListUserPopular event type. */
		public static const TAGS_GET_LIST_USER_POPULAR:String = "tagsGetListUserPopular";
		
		/** Constant for the tagsGetRelated event type. */
		public static const TAGS_GET_RELATED:String = "tagsGetRelated";
		
		/** Constant for the testEcho event type. */
		public static const TEST_ECHO:String = "testEcho";
		
		/** Constant for the testLogin event type. */
		public static const TEST_LOGIN:String = "testLogin";
		
		/** Constant for the urlsGetGroup event type. */
		public static const URLS_GET_GROUP:String = "urlsGetGroup";
		
		/** Constant for the urlsGetUserPhotos event type. */
		public static const URLS_GET_USER_PHOTOS:String = "urlsGetUserPhotos";
		
		/** Constant for the urlsGetUserProfile event type. */
		public static const URLS_GET_USER_PROFILE:String = "urlsGetUserProfile";
		
		/** Constant for the urlsLookupGroup event type. */
		public static const URLS_LOOKUP_GROUP:String = "urlsLookupGroup";
		
		/** Constant for the urlsLookupUser event type. */
		public static const URLS_LOOKUP_USER:String = "urlsLookupUser";
		
		public static const SET_LOCATION_RESULT:String = "setLocationResult";
		
		
		/**
		 * True if the event is the result of a successful call,
		 * False if the call failed
		 */
		public var success:Boolean;
		
		/**
		 * Constructs a new FlickrResultEvent
		 */
		public function FlickrResultEvent( type:String, 
										   bubbles:Boolean = false, 
										   cancelable:Boolean = false ) {
										   	
			super( type, bubbles, cancelable );
		}
	
	}
	
}