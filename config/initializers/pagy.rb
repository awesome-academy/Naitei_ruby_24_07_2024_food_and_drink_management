require "pagy/extras/metadata"
require "pagy/extras/overflow"
Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT[:items] = 3
