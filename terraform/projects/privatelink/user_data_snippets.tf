variable "user_data_snippets" {
  type        = "list"
  description = "List of user-data snippets"
}

# Resources
# --------------------------------------------------------------

resource "null_resource" "user_data" {
  count = "${length(var.user_data_snippets)}"

  triggers {
    snippet = "${file("../../userdata/${element(var.user_data_snippets, count.index)}")}"
  }
}
