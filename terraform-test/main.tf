variable "myvar" {
    type = string
    default = "hello terraform"
}

variable "mymap" {
    type = map(string)
    default = {
        "mykey1" = "my value 1"
        "mykey2" = "my value 2"
    }
}

variable "mylist" {
    type = list # if you omit the type it will try to infer it
    default = [1,2,3]
}