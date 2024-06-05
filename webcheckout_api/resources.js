require('dotenv').config();
const axios = require('axios');
const host = "https://webcheckout.lsa.umich.edu";
console.log("userid", process.env.USERID)
const userid = process.env.USERID;
const password = process.env.PASSWORD;
let sessionToken = "Bearer Requested"
const fs = require('node:fs');

try {
  locations = fs.readFileSync('webcheckout_api/files/locations_oids.txt', 'utf8');
  console.log(locations);
} catch (err) {
  console.error(err);
}

const location_oids = locations.split(" ").map(str => parseInt(str, 10));

async function start_session() {
  return axios.request({
    method: "POST",
    url: host + "/rest/session/start",
    headers: {
      "Authorization": sessionToken
    },
    data: {
      "userid": userid,
      "password": password
    }
  });
}

async function get_resources(oid) {
  return axios.request({
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
    }
  });
}

function write_resources_to_file(oid, resources) {
  for (item of resources["result"]) {
    fs.appendFileSync('webcheckout_api/files/resources.txt', + oid + ';;' + item.name + ';;' + item.resourceType.name + '\n', function(err){
      if(err)
        return err;
    });
  }
}

async function end_session() {
  axios.request({
    method: "POST",
    url: host + "/rest/session/logout",
    headers: {
      "Authorization": "Bearer" + sessionToken
    }
  });
}

async function main() {
  ({ data: { sessionToken } } = await start_session());

  for (const oid of location_oids) {
    console.log(oid)
    try {
      const { data: { payload } } = await get_resources(oid);
      if (payload.count > 0) write_resources_to_file(oid, payload);
    } catch (error) {
      console.error('Error updating resources for oid', oid, ':', error);
    }
  }

  await end_session();
}

main().catch(error => {
  console.error('Error:', error);
});
