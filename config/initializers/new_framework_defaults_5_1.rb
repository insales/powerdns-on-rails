# Be sure to restart your server when you modify this file.
#
# This file contains migration options to ease your Rails 5.1 upgrade.
#
# Once upgraded flip defaults one by one to migrate to the new default.
#
# Read the Guide for Upgrading Ruby on Rails for more info on each option.

# Unknown asset fallback will return the path passed in when the given
# asset is not present in the asset pipeline.

# TODO: fix the ui/migrate to assets and remove
Rails.application.config.assets.unknown_asset_fallback = true
