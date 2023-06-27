##Resource to create rds cluster
resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${var.env}-rds"
  engine                  = var.engine
  engine_version          = var.engine_version
  /* availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"] */
  database_name           = var.database_name
  master_username         = data.aws_ssm_parameter.user.value
  master_password         = data.aws_ssm_parameter.pass.value
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  db_subnet_group_name     = aws_db_subnet_group.main.name
  /* skip_final_snapshot = var.skip_final_snapshot */

  tags = merge(
    var.tags,
    { Name = "${var.env}-rds" }
  )
}


##Document SubnetGroup for RDS
resource "aws_db_subnet_group" "main" {
  name       =  "${var.env}-rds"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    { Name = "${var.env}-subnet-group" }
  )
  lifecycle {
    create_before_destroy = true
  }
}

#Createing RDS Cluster Instance
resource "aws_rds_cluster_instance" "main" {
  count              = var.no_of_instances
  identifier         = "${var.env}-rds-${count.index}"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = var.instance_class
  engine                  = var.engine
  engine_version          = var.engine_version

}
#final_snapshot_identifier
#skip_final_snapshot
#Error: RDS Cluster final_snapshot_identifier is required when skip_final_snapshot is false