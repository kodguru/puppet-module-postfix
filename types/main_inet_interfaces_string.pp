# Data type for string value for inet_interfaces in main.conf
type Postfix::Main_inet_interfaces_string = Variant[
  Enum[
    'all',
    'loopback-only'
  ],
  Stdlib::Host,
  Postfix::Ipv6_address_brackets,
  Postfix::Variables,
]
