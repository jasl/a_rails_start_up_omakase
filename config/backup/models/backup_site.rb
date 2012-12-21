# encoding: utf-8

setting = YAML.load_file("#{File.dirname(Config.config_file)}/../application.yml").fetch('production')
database = YAML.load_file("#{File.dirname(Config.config_file)}/../database.yml").fetch('production')
##
# Backup Generated: my_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t my_backup [-c <path_to_configuration_file>]
#
Backup::Model.new(:backup_site, 'Backup sql') do
  ##
  # Split [Splitter]
  #
  # Split the backup file in to chunks of 250 megabytes
  # if the backup file size exceeds 250 megabytes
  #
  split_into_chunks_of 250

  ##
  # MySQL [Database]
  #
  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = database["database"]
    db.username           = database["username"]
    db.password           = database["password"]
    db.host               = "localhost"
    db.port               = 3306
    # db.socket             = "/tmp/mysql.sock"
    # Note: when using `skip_tables` with the `db.name = :all` option,
    # table names should be prefixed with a database name.
    # e.g. ["db_name.table_to_skip", ...]
    # db.skip_tables        = ["skip", "these", "tables"]
    # db.only_tables        = ["only", "these" "tables"]
    db.additional_options = ["--quick", "--single-transaction"]
    # Optional: Use to set the location of this utility
    #   if it cannot be found by name in your $PATH
    # db.mysqldump_utility = "/opt/local/bin/mysqldump"
  end

  ##
  # GPG [Encryptor]
  #
  # Setting up #keys, as well as #gpg_homedir and #gpg_config,
  # would be best set in config.rb using Encryptor::GPG.defaults
  #
  #encrypt_with GPG do |encryption|
  #  # Setup public keys for #recipients
  #  encryption.keys = {}
  #  encryption.keys['user@domain.com'] = <<-KEY
  #    -----BEGIN PGP PUBLIC KEY BLOCK-----
  #    Version: GnuPG v1.4.11 (Darwin)
  #
  #        <Your GPG Public Key Here>
  #    -----END PGP PUBLIC KEY BLOCK-----
  #  KEY
  #
  #  # Specify mode (:asymmetric, :symmetric or :both)
  #  encryption.mode = :both # defaults to :asymmetric
  #
  #  # Specify recipients from #keys (for :asymmetric encryption)
  #  encryption.recipients = ['user@domain.com']
  #
  #  # Specify passphrase or passphrase_file (for :symmetric encryption)
  #  encryption.passphrase = 'a secret'
  #  # encryption.passphrase_file = '~/backup_passphrase'
  #end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the Wiki for other delivery options.
  # https://github.com/meskyanichi/backup/wiki/Notifiers
  #
  #notify_by Mail do |mail|
  #  mail.on_success           = true
  #  mail.on_warning           = true
  #  mail.on_failure           = true
  #
  #  mail.from                 = "sender@email.com"
  #  mail.to                   = "receiver@email.com"
  #  mail.address              = "smtp.gmail.com"
  #  mail.port                 = 587
  #  mail.domain               = "your.host.name"
  #  mail.user_name            = "sender@email.com"
  #  mail.password             = "my_password"
  #  mail.authentication       = "plain"
  #  mail.enable_starttls_auto = true
  #end

  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.delivery_method      = :sendmail
    mail.from                 = "backup@mail.#{setting["domain"]}"
    mail.to                   = setting["admin_mail"]

    # optional settings:
    mail.sendmail             # the full path to the `sendmail` program
    mail.sendmail_args        # string of arguments to to pass to `sendmail`
  end

  store_with Local do |local|
    local.path = setting["deployment"]["backup_path"]
  end
end
