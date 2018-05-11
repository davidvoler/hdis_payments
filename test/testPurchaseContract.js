var assert = require('assert');
require('truffle-test-utils').init();
;var HdisContent = artifacts.require('../contracts/HdisContent.sol');

contract('HdisContent', function(accounts){

        it('should test that the HdisContent contract can be deployed', function(done){
            HdisContent.new().then(function(instance){
                assert.ok(instance.address);
            }).then(done);
        });

        it('should test that the HdisContent contract is deployed by the correct address (default)', function(done){
            HdisContent.new().then(function(instance){
                var test = instance;
                test.owner.call().then(function(owner){
                    assert.equal(owner, accounts[0], 'HdisContent owned by the wrong address');
                }).then(done);
            });
        });

        it('should test that the HdisContent contract is deployed by the correct address (using from)', function(done){
            HdisContent.new({from: accounts[0]}).then(function(instance){
                var test = instance;
                test.owner.call().then(function(owner){
                    assert.equal(owner, accounts[0], 'HdisContent owned by the wrong address');
                }).then(done);
            });
        });
        

        it('should test that content can be purchased', function(done){
            HdisContent.new({from: accounts[0]}).then(function(instance){
                const name = "test";
                const mediaId = 1;
                const mediaType = 2;
                const creator = 0;
                const rightPrice = "10";
                instance.addContent.call(name, mediaId, mediaType, creator, rightPrice).then(
                  async function(contentId) {
                    let result = await instance.purchaseContent.call(contentId, {value: (rightPrice)});
                    assert.web3Event(result, {
                      event: "purchaseContentEvent",
                      args: {
                        content: [mediaId, mediaType, creator, rightPrice],
                        buyer: accounts[0]
                      }
                    }, "No purchase event");
                  }).then(done);
            });
        });
        
        it('should test that content can be purchased too cheaply', function(done){
            HdisContent.new({from: accounts[0]}).then(function(instance){
                const name = "test";
                const mediaId = 1;
                const mediaType = 2;
                const creator = 0;
                const lowPrice = "5";
                instance.addContent.call(name, mediaId, mediaType, creator, lowPrice).then(
                  function(contentId){
                    instance.purchaseContent.call(contentId, {value: web3._extend.utils.toWei(lowPrice - 1)}).then(
                      function(events){
                        console.log(events);
                        assert.equal(events.length, 0, "event emitted");
                      });
                  }).then(done);
            });
        });
});
