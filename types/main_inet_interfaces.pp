# Data type for inet_interfaces in main.conf
type Postfix::Main_inet_interfaces = Variant[
  Postfix::Main_inet_interfaces_string,
  Postfix::Main_inet_interfaces_array,
]
