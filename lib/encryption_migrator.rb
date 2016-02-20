require "encryption_migrator/version"

module EncryptionMigrator
  def self.constant_for(model)
    model.to_s.singularize.camelize.constantize
  end

  def self.define_class_with_encrypted(const, attr, encrypted_attr, key)
    const.class_eval do
      attr_encrypted attr, key: key, attribute: encrypted_attr
    end
  end

  def self.decrypt_and_update_row(row, const, column, key)
    encrypted_sym = encrypted_column_sym(column)
    define_class_with_encrypted(const, column, encrypted_sym, key)
    attr = const.decrypt(column, row.read_attribute(encrypted_sym))
    row.update_column(:"#{column}", attr)
  end

  def self.encrypted_column_sym(column)
    :"encrypted_#{column}"
  end
end

class ActiveRecord::Migration
  def unencrypt_field(model, column, key:)
    const = EncryptionMigrator.constant_for(model)
    encrypted_sym = :"encrypted_#{column}"

    add_column model, column, :string
    const.reset_column_information

    const.all.each do |row|
      EncryptionMigrator.decrypt_and_update_row(row, const, column, key)
    end

    remove_column model, encrypted_sym
  end
end
