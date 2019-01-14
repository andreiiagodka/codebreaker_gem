# frozen_string_literal: true

require 'yaml'
require 'i18n'
require 'terminal-table'

require_relative 'config/i18n'

require_relative 'lib/app/helpers/output_helper'
require_relative 'lib/app/helpers/output'
require_relative 'lib/app/helpers/failing'

require_relative 'lib/app/modules/console_user_interaction'

require_relative 'lib/app/entities/console'
require_relative 'lib/app/entities/validated_entity'
require_relative 'lib/app/entities/player'
require_relative 'lib/app/entities/difficulty'
require_relative 'lib/app/entities/guess'
require_relative 'lib/app/entities/game'
require_relative 'lib/app/entities/statistic'
