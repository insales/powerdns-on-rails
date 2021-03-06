FactoryBot.define do

  sequence :domain_name do |i|
    "example#{i}.com"
  end

  factory :domain, :class => 'Domain' do
    name { generate :domain_name }
    # add_attribute :type, 'NATIVE'
    type { "NATIVE" }
    ttl  { 86400 }
    # soa
    primary_ns { |d| "ns1.#{d.name}" }
    contact { |d| "admin@#{d.name}" }
    refresh { 10800 }
    self.retry { 7200 } # retry is a keyword in ruby
    expire { 604800 }
    minimum { 10800 }
  end


  factory :record do
    domain

    #factory(:soa, :class => 'Record::SOA') do |f|
    #  name { |r| r.domain.name }
    #  ttl 86400
    #  #content { |r| "ns1.#{r.domain.name} admin@#{r.domain.name} 2008040101 10800 7200 604800 10800" }
    #  primary_ns { |r| "ns1.#{r.domain.name}" }
    #  contact { |r| "admin@#{r.domain.name}" }
    #  refresh 10700
    #  retry 7200
    #  expire 604800
    #  minimum 10800
    #end

    factory(:ns, :class => Record::NS) do
      ttl { 86400 }
      name { |r| r.domain.name }
      content { |r| "ns1.#{r.domain.name}" }
    end

    factory(:ns_a, :class => Record::A) do
      ttl  { 86400 }
      name { |r| "ns1.#{r.domain.name}" }
      content { "10.0.0.1" }
    end

    factory(:a, :class => Record::A) do
      ttl { 86400 }
      name { |r| r.domain.name }
      content { '10.0.0.3' }
    end

    factory(:www, :class => Record::A) do
      ttl { 86400 }
      name { |r| "www.#{r.domain.name}" }
      content { '10.0.0.3' }
    end

    factory(:mx, :class => Record::MX) do
      ttl { 86400 }
      name { |r| r.domain.name }
      content { |r| "mail.#{r.domain.name}" }
      prio { 10 }
    end

    factory(:mx_a, :class => Record::A) do
      ttl { 86400 }
      name { |r| "mail.#{r.domain.name}" }
      content { '10.0.0.4' }
    end
  end
end
