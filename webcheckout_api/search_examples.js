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
      data: {}
    })
  }).then(response => {
    payload = response.data.payload;
    console.log(payload)
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





works:

//  1) to get oid for 'CCCB 0420': 538519922,
url: host + "/rest/resource/search",

 "query": {
    name: 'CCCB 0420'
  }

// 2) to get resourses for homeLocation 'CCCB 0420': 538519922,
url: host + "/rest/resource/search",

"query":{
    "and":{
      "homeLocation":{
        "_class":"resource",
        "oid":538519922,
      }
    }
  }

  //  3) get oid for resourseType 'Wireless Bodypack Transmitter': 127903215
  url: host + "/rest/resourceType/search",

  "query": {
    name: 'Wireless Bodypack Transmitter'
  }
  //  4) get list of Wireless Bodypack Transmitters for the room
  url: host + "/rest/resource/search",
  "query":{
    "and":{
      "homeLocation":{
        "_class":"resource",
        "oid": 538519922
      },
      "resourceTypeAncestor":{
        "_class":"resourceType",
        "oid":127903215
      }
    }
  }
  