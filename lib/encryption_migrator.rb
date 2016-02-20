require "encryption_migrator/version"

module EncryptionMigrator
  def self.constant_for(model)
    model.to_s.singularize.camelize.constantize
  end

  def self.define_class_with_encrypted(model_const, attr, encrypted_attr, key)
    model_const.class_eval do
      attr_encrypted attr, key: key, attribute: encrypted_attr
    end
  end

  def self.decrypt_and_update_column(model_arg, model_const, column, key)
    encrypted_sym = encrypted_column_sym(column)
    define_class_with_encrypted(model_const, column, encrypted_sym, key)
    attr = model_const.decrypt(column, model_arg.read_attribute(encrypted_sym))
    model_arg.update_column(:"#{column}", attr)
  end

  def self.encrypted_column_sym(column)
    :"encrypted_#{column}"
  end
end

class ActiveRecord::Migration
  def unencrypt_field(model, column, key:)
    model_const = EncryptionMigrator.constant_for(model)
    encrypted_sym = :"encrypted_#{column}"

    add_column model, column, :string
    model_const.reset_column_information

    model_const.all.each do |model_arg|
      EncryptionMigrator.decrypt_and_update_column(model_arg, model_const, column, key)
    end

    remove_column model, encrypted_sym
  end
end
