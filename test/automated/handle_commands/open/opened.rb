require_relative '../../automated_init'

context "Handle Commands" do
  context "Open" do
    context "Opened" do
      handler = Handlers::Commands.new

      processed_time = Time.utc(2000, 1, 1, 0, 0, 0, 11000)
      handler.clock.now = processed_time

      open = Messages::Commands::Open.new

      account_id = "00000001-0000-4000-8000-000000000000"
      open.account_id = account_id

      customer_id = "00000011-0000-4000-8000-000000000000"
      open.customer_id = customer_id

      effective_time = Time.utc(2000, 1, 1, 0, 0, 0, 1000)
      effective_time_iso8601 = effective_time.iso8601
      open.time = effective_time_iso8601

      handler.(open)

      writer = handler.write

      opened = writer.one_message do |event|
        event.instance_of?(Messages::Events::Opened)
      end

      test "Opened Event is Written" do
        refute(opened.nil?)
      end

      test "Written to the account stream" do
        written_to_stream = writer.written?(opened) do |stream_name|
          stream_name == "account-#{account_id}"
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "account_id" do
          assert(opened.account_id == account_id)
        end

        test "customer_id" do
          assert(opened.customer_id == customer_id)
        end

        test "time" do
          assert(opened.time == effective_time_iso8601)
        end

        test "processed_time" do
          processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

          assert(opened.processed_time == processed_time_iso8601)
        end
      end
    end
  end
end
