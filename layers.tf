# resource "null_resource" "install_layer_deps" {
#   triggers = {
#     layer_build = filemd5("${local.layers_path}/utils/nodejs/package.json")
#   }

#   provisioner "local-exec" {
#     working_dir = "${local.layers_path}/utils/nodejs"
#     command     = "npm install"
#   }
# }