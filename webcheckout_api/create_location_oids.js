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
  rooms = fs.readFileSync('webcheckout_api/files/room_rmrecnbr.txt', 'utf8');
} catch (err) {
  console.error(err);
}

const r = rooms.split(" ")

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

async function get_location_oids() {
  return axios.request({
    method: "POST",
    url: host + "/rest/resource/search",
    headers: {
      "Authorization": "Bearer " + sessionToken
    },
    data: {
      "query": {
        barcode: r
      }
    }
  })
}

function write_get_location_oids_to_file(oids) {
  console.log(oids)
  const location_oids = oids.map(item => item.oid).join(' ');
  const roomLocationData = oids.map(item => `${item.barcode} ${item.oid}`).join('\n');
  fs.writeFileSync('webcheckout_api/files/locations_oids.txt', location_oids);
  fs.appendFileSync('webcheckout_api/files/room_location.txt', roomLocationData)
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

  const { data: { payload: { result } } } = await get_location_oids();
  write_get_location_oids_to_file(result);

  await end_session();
}

main().catch(error => {
  console.error('Error:', error);
});