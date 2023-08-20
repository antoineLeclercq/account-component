module AccountComponent
  module Controls
    module Write
      module Deposit
        def self.call(id: nil, account_id: nil, amount: nil)
          id ||= Identifier::UUID::Random.get
          account_id ||= Identifier::UUID::Random.get
          amount ||= Money.example

          deposit = Commands::Deposit.example(
            id: id,
            account_id: account_id,
            amount: amount
          )

          stream_name = Messaging::StreamName.command_stream_name(account_id, 'account')

          Messaging::Postgres::Write.(deposit, stream_name)

          deposit
        end
      end
    end
  end
end
