# Data type for array values for inet_interfaces in main.conf
type Postfix::Main_inet_interfaces_array = Array[
  Variant[
    Stdlib::Host,
    Postfix::Ipv6_address_brackets,
    Postfix::Variables,
  ],
]
