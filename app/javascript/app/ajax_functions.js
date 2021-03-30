import { authenticatedFetch } from '@shopify/app-bridge-utils'
const domain = "rjz.ngrok.io"

/*Email*/
export function sendEmailAndCharge(to, subject = "", app) {
    const endpoint = "https://" + domain + "/billing/send_email";


}

/*Billing*/
export function updatePlan(planName) {
    const endpoint = "https://" + domain + "/billing/update";
    // const authString = 'Bearer ' + window.authToken;
    setLoading(true);
    // myAuthenticatedFetch(endpoint, { headers: { "Authorization": authString } })
    return doFetch(endpoint)
        .then((response) => response.json())
        .then((data) => {
            debugger;
        })
        .then((json) => {
            debugger;
        })
}

export function fetchCurrentPlan(planName) {
    const endpoint = "https://" + domain + "/billing/show";
    const authString = 'Bearer ' + window.authToken;
    return fetch(endpoint, { headers: { "Authorization": authString } })
        .then((response) => response.json())
        .then((jsonData) => {
            const plan = jsonData.plan.data;
            debugger;
            var planElement = document.getElementById("current-plan");
        })
        .catch((error) => {
            debugger;
        })
}


/* Helpers */

export function setLoading(isLoading) {
    var element = document.getElementById("loading");
    if (isLoading) {
        element.classList.remove("d-none");
    } else {
        element.classList.add("d-none");
    }
}