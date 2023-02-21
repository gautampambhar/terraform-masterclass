**What**: it's a local varibale used in the terraform configuration. Think of this as a varibale defined in the function.

**When**: When you want to use variable locally in the terraform files. A varibale that gets used many time locally. Increase reusability  

**How**: define local block with varibale and it's value. and reference this local value in the resources same as varibale. 