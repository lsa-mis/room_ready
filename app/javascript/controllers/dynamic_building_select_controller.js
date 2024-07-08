import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dynamic-building-select"
export default class extends Controller {
  static targets = ["zoneSelect", "buildingSelect", "buildingsData"];

  connect() {
    const buildings = JSON.parse(this.buildingsDataTarget.dataset.buildings);
    this.zoneBuildingMap = buildings.reduce((map, [zoneId, buildingName, buildingId]) => {
      if (!map[zoneId]) {
        map[zoneId] = [];
      }
      map[zoneId].push({ id: buildingId, name: buildingName });
      return map;
    }, {})
    this.initializeBuildingFromParams();
  }

  initializeBuildingFromParams()
  {
    this.updateBuildings();
    const urlParams = new URLSearchParams(window.location.search);
    const buildingId = urlParams.get('building_id');
    if (buildingId) this.buildingSelectTarget.value = buildingId;
  }

  updateBuildings() {
    const zoneId = this.zoneSelectTarget.value;
    const buildings = this.zoneBuildingMap[zoneId] || [];
    this.buildingSelectTarget.innerHTML = '<option value="">All Buildings</option>';
    this.buildingSelectTarget.innerHTML += buildings.map(({ id, name }) => {
      return `<option value="${id}">${name}</option>`;
    }).join("")
    this.buildingSelectTarget.disabled = buildings.length === 0;
  }
}
