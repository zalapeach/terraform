data "external" "env" {
  program = ["${path.module}/scripts/env.sh"]
}
