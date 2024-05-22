import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "bldrecnbr", "name", "nickName", "address", "city", "state", "zip"];

  connect() {
    console.log("connect building");
  }

  populateFields(event) {
    const selectedBuildingId = event.target.value;

    fetch(`/buildings/${selectedBuildingId}.json`)
      .then(response => response.json())
      .then(data => {
        
        this.bldrecnbrTarget.value = data.bldrecnbr || '';
        this.nameTarget.value = data.name || '';
        this.nickNameTarget.value = data.nick_name || '';
        this.addressTarget.value = data.address || '';
        this.cityTarget.value = data.city || '';
        
        this.setStateValue(data.state);
        
        this.zipTarget.value = data.zip || '';
      })
      .catch(error => {
        console.error("Error fetching building data", error);
      });
  }

  setStateValue(state) {
    const option = Array.from(this.stateTarget.options).find(opt => opt.value === state);
    if (option) {
      this.stateTarget.value = option.value;
    } else {
      this.stateTarget.value = '';
    }
  }
}