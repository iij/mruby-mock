mruby-mock
==========

### For example:

test.rb: 

     mock = Mocks::Mock.new
     mock.stubs(:code).returns("200")
     mock.stubs(:body).returns("success")

     p mock.code
     p mock.body

run:

     $ mruby test.rb
     "200"
     "success"
     
	


        