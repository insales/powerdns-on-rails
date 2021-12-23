# из-за belongs_to :user в Audit, причем надо до самой модели выставить
Rails.application.config.active_record.belongs_to_required_by_default = false

require 'audited/audit'
Audit = Audited::Audit

# пока не тащим миграцию из audited:upgrade, т.к. таблица там большая
class Audit
  attr_accessor :request_uuid
end
