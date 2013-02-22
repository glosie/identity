require "base64"
require "rack/session/cookie"

module Identity
  class FernetCookieCoder
    def initialize(*keys)
      @keys = keys.compact
    end

    def encode(raw)
      data = Base64.urlsafe_encode64(Marshal.dump(raw))
      Fernet.generate(@keys.first) do |generator|
        # use Marshal instead of JSON to avoid trouble with string/symbol
        # conversions
        generator.data = { "session" => data }
      end
    end

    def decode(cipher)
      plain = nil
      @keys.each do |key|
        begin
          plain = decode_with_key(cipher, key)
        rescue OpenSSL::Cipher::CipherError
        end
      end
      raise "no valid encryption key for cipher" if !plain
      plain
    # fernet throws random exceptions :{ eat it for now
    rescue Exception => e
      Slides.log(:exception, class: e.class.name, message: e.message)
      {}
    end

    private

    def decode_with_key(cipher, key)
      verifier = Fernet.verifier(key, cipher)
      verifier.enforce_ttl = false
      verifier.verify_token(cipher)
      raise "cipher invalid" unless verifier.valid?
      Marshal.load(Base64.urlsafe_decode64(verifier.data["session"]))
    end
  end
end
