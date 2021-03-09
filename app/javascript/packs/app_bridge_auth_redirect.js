import createApp from '@shopify/app-bridge';
import { Redirect } from '@shopify/app-bridge/actions';

//pull out data passed to the view by the controller
const controllerData = document.getElementById("url-data");
const apiKey = controllerData.dataset.apiKey;
const shopOrigin = controllerData.dataset.shopName;
const permissionUrl = controllerData.dataset.permissionUrl;

// If the current window is the 'parent', change the URL by setting location.href
if (window.top == window.self) {
    window.location.assign(permissionUrl);

// If the current window is the 'child', change the parent's URL with Shopify App Bridge's Redirect action
} else {
    var app = createApp({
        apiKey: apiKey,
        shopOrigin: shopOrigin
    });

    Redirect.create(app).dispatch(Redirect.Action.REMOTE, permissionUrl);
}