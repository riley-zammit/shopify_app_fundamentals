import createApp from '@shopify/app-bridge';
import { getSessionToken, authenticatedFetch } from '@shopify/app-bridge-utils'
import axios from 'axios'
import { sendEmailAndCharge, getCurrentPlan } from './ajax_functions'

document.addEventListener("DOMContentLoaded", () => {
    const controllerData = document.getElementById("url-data");

    const app = createApp({
        apiKey: controllerData.dataset.apiKey,
        shopOrigin: controllerData.dataset.shopOrigin,
        forceRedirect: true
    });
    window.app = app;
    // get session token from App Bridge
    getSessionToken(app)
        .then((token) => {

            attachDomEventListeners();
            displayPageContent();
        }).catch((error) => {
            console.log("Error getting session token from app bridge!");
        });
})


function attachDomEventListeners() {
    document.getElementById("get-current-plan-button").addEventListener("click", () => getCurrentPlan('main'));
}

function displayPageContent() {
    document.getElementById('loading-message').classList.add('d-none');
    const mainContent = document.getElementById('main-content');
    mainContent.classList.add('d-flex');
    mainContent.classList.remove('d-none')
}