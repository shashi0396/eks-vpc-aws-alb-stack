                  modules/eks-stack
                         ▲
                         │
            ┌────────────┼────────────┐
            │            │            │
            │            │            │
           dev        preprod       prod
            │            │            │
        Terragrunt   Terragrunt   Terragrunt

### Architecture

eks-vpc-aws-alb-stack/
│
├── modules/
│   └── eks-stack/
│       ├── vpc.tf
│       ├── eks.tf
│       ├── node-group.tf
│       ├── alb-controller.tf
│       ├── provider.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       └── iam-policy.json
│
└── live/
    ├── terragrunt.hcl
    └── us-east-1/
        └── dev/
            └── terragrunt.hcl


cd live/us-east-1/dev

terragrunt init
terragrunt plan
terragrunt apply
terragrunt destroy