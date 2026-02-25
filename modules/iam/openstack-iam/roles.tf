data "openstack_identity_role_v3" "member" {
    name = var.role_member
}

data "openstack_identity_role_v3" "heat_stack_owner" {
    name = "heat_stack_owner"
}

data "openstack_identity_role_v3" "heat_stack_user" {
    name = "heat_stack_user"
}

data "openstack_identity_role_v3" "reader" {
    name =var.role_reader
}

resource "openstack_identity_role_assignment_v3" "env_role" {
  project_id = openstack_identity_project_v3.project.id
  group_id   = openstack_identity_group_v3.group.id

  role_id = (
    var.environment == "prod"
      ? data.openstack_identity_role_v3.reader.id
      : data.openstack_identity_role_v3.member.id
  )
}



