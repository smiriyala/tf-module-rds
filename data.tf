data "aws_ssm_parameter" "user"{
    name = "${var.env}.rds.user"
}

data "aws_ssm_parameter" "pass"{
    name = "${var.env}.rds.pass"
}

data "aws_kms_key" "key"{
    key_id = "alias/roboshop"
}