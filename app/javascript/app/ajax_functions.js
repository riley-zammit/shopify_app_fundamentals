import { authenticatedFetch } from '@shopify/app-bridge-utils'
const domain = "rjz.ngrok.io"

/*Email*/
export function sendEmailAndCharge(to, subject = "", app) {
    const endpoint = "https://" + domain + "/billing/update";


}

/*Billing*/
export function updatePlan(planName) {
    const endpoint = "https://" + domain + "/billing/update/" + planName;
    const authString = 'Bearer ' + window.authToken;
    setLoading(true);
    var myAuthenticatedFetch = authenticatedFetch(window.app);
    myAuthenticatedFetch(endpoint, { headers: { "Authorization": authString } })
        .then((response) => response.json())
        .then((json) => {
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