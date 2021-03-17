import createApp from '@shopify/app-bridge';
import { getSessionToken, authenticatedFetch } from '@shopify/app-bridge-utils'
import axios from 'axios'
import { sendEmailAndCharge, fetchCurrentPlan, updatePlan } from './ajax_functions'

document.addEventListener("DOMContentLoaded", () => {
    const controllerData = document.getElementById("url-data");

    //instantiate App Bridge app and put into window for easy global access
    const app = createApp({
        apiKey: controllerData.dataset.apiKey,
        shopOrigin: controllerData.dataset.shopOrigin,
        forceRedirect: true
    });
    // window.app = app;

    // get session token from App Bridge
    getSessionToken(app)
        .then((token) => {
            window.authToken = token
            attachDomEventListeners();
            displayPageContent();
            return fetchCurrentPlan();
        })
        .then((plan) => {
            debugger;
        })
        // .catch((error) => {
        //     debugger;
        //     console.log("Error getting session token from app bridge!");
        // });


})


function attachDomEventListeners() {
    document.getElementById("send-email-button").addEventListener("click", () => sendEmailAndCharge());

    var planButtons = document.getElementById("plans-display").getElementsByTagName("button");
    for (var i = 0; i < planButtons.length; i++) {
        planButtons[i].addEventListener("click", () => updatePlan(planButtons[i].id));
    }
}

function displayPageContent() {
    document.getElementById('loading-message').classList.add('d-none');
    const mainContent = document.getElementById('main-content');
    mainContent.classList.add('d-flex');
    mainContent.classList.remove('d-none')
}