require('dotenv').config();
const axios = require('axios');
const host = "https://webcheckout.lsa.umich.edu";
console.log("userid", process.env.USERID)
const userid = process.env.USERID;
const password = process.env.PASSWORD;
let sessionToken = "Bearer Requested"
const fs = require('node:fs');
var rooms = ""

try {
  rooms = fs.readFileSync('files/room_rmrecnbr.txt', 'utf8');
} catch (err) {
  console.error(err);
}

const r = rooms.split(" ")

axios.request({
  method: "POST",
  url: host + "/rest/session/start",
  headers: {
    "Authorization": sessionToken
  },
  data: {
    "userid": userid,
    "password": password
  }
  }).then(response => {
    sessionToken = response.data.sessionToken;
    return axios.request({
      method: "POST",
      url: host + "/rest/resource/search",
      headers: {
        "Authorization": "Bearer " + sessionToken
      },
      data: {
        //  1
        "query": {
          barcode: r
        }
      }
    })
  }).then(response => {
    payload = response.data.payload;
    var location_oids = ""
    // console.log(payload)
    for (item of payload["result"]) {
      // console.log("item")
      // console.log(item.oid)
      location_oids += item.oid + " "
      // console.log(location_oids)
      fs.writeFileSync('files/locations_oids.txt', location_oids);
      fs.appendFileSync('files/room_location.txt', + item.barcode + ' ' + item.oid + '\n')
    }
  }).then(() => {
    // log out of the API.
    axios.request({
      method: "POST",
      url: host + "/rest/session/logout",
      headers: {
        "Authorization": "Bearer" + sessionToken
      }
    })
  }).catch(error => {
    console.error(error);
});
