import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bldrecnbr", "name", "nickName", "address", "city", "state", "zip"];

  connect() {
    console.log("Hello World!");
  }
}
