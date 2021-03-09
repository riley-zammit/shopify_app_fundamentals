import createApp from '@shopify/app-bridge';

const controllerData = document.getElementById("url-data");
const app = createApp({
    apiKey: controllerData.dataset.apiKey,
    shopOrigin: controllerData.dataset.shopOrigin,
    forceRedirect: true
});