import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "summary", "list"]

  browse() {
    this.inputTarget.click()
  }

  update() {
    const files = Array.from(this.inputTarget.files)

    if (files.length === 0) {
      this.summaryTarget.textContent = "No files selected"
      this.listTarget.textContent = ""
      return
    }

    this.summaryTarget.textContent =
      files.length === 1 ? "1 file selected" : `${files.length} files selected`
    this.listTarget.textContent = files.map((file) => file.name).join(", ")
  }
}
