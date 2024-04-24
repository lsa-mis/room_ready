require('dotenv').config();
const axios = require('axios');
const host = "https://webcheckout.lsa.umich.edu";
console.log("userid", process.env.USERID)
const userid = process.env.USERID;
const password = process.env.PASSWORD;
let sessionToken = "Bearer Requested"
const fs = require('node:fs');

try {
  locations = fs.readFileSync('files/locations_oids.txt', 'utf8');
  console.log(locations);
} catch (err) {
  console.error(err);
}

const location_oids = locations.split(" ")

let promises = [];
let resources = [];

const createResourcesFile = function(oid) {
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
    console.log(oid)
    promises.push(
      axios.request({
        method: "POST",
        url: host + "/rest/resource/search",
        headers: {
          "Authorization": "Bearer " + sessionToken
        },
        data: {
          "query": {
            "and":{
              "homeLocation":{
                "_class":"resource",
                "oid": oid
              }
            }
          },
          "properties":["resourceType"],
        },
      }).then(response => {
        payload = response.data.payload;
        // console.log(payload)
        // console.log(oid)
        if (payload.count > 0) {
          for (item of payload["result"]) {
            fs.appendFileSync('files/resources.txt', + oid + ';;' + item.name + ';;' + item.resourceType.name + '\n', function(err){
              if(err)
                return err;
            })
          }
        }
      })
    )
    
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
  })
}

location_oids.forEach(function(oid_s) {
  var oid = parseInt(oid_s)
  createResourcesFile(oid)
}, 10000)
