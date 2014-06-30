module Quandl
  class Pattern

    define_pattern :dataset_date, /[0-9]{4}\-[0-9]{2}\-[0-9]{2}/, example: "yyyy-mm-dd"
    define_pattern :code, /[A-Z0-9_]+/, example: 'ALPHA_NUMERIC_ALL_CAPS'
    define_pattern :full_code, /(#{code}+)\/?(#{code})?/, example: "(SOURCE_CODE/)#{code.to_example}"

  end
end