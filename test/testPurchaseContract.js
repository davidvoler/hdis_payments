import { inLogs } from './expectEvent';
var assert = require('assert');
var HdisContent = artifacts.require('../contracts/HdisContent.sol');

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
                let b1 = web3.eth.getBalance(accounts[0]);
                instance.addContent.call(name, mediaId, mediaType, creator, rightPrice).then(
                  function(contentId) {
                    instance.purchaseContent.call(contentId, {value: (rightPrice), sender: accounts[0]}).then(function(){
                    let b2 = web3.eth.getBalance(accounts[0]);
                    assert.notEqual(b1, b2, "Balance not changed");
                    });
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
                        assert.equal(events.length, 0, "event emitted");
                      });
                  }).then(done);
            });
        });
        
        it('should test that content can be contributed to', function(done){
            HdisContent.new({from: accounts[0]}).then(function(instance){
                const name = "test";
                const mediaId = 1;
                const mediaType = 2;
                const creator = 0;
                const rightPrice = "10";
                instance.addContent.call(name, mediaId, mediaType, creator, rightPrice).then(
                  function(contentId) {
                     instance.addContributor(contentId, accounts[0]); 
                  }).then(done);
            });
        });
        
        it('should test that payments are distributed', function(done){
            HdisContent.new({from: accounts[0]}).then(function(instance){
                const name = "test";
                const mediaId = 1;
                const mediaType = 2;
                const creator = 0;
                const rightPrice = "10";
                instance.addContent.call(name, mediaId, mediaType, creator, rightPrice).then(
                  function(contentId) {
                     instance.addContributor(contentId, accounts[1]); 
                     instance.addContributor(contentId, accounts[2]); 
                     let b1Before = web3.eth.getBalance(accounts[1]);
                     instance.purchaseContent.call(
                       contentId, {value: (rightPrice), sender: accounts[0]}).then(
                         function(){
                            let b1After = web3.eth.getBalance(accounts[1]);
                            assert.notEqual(b1Before, b1After, "balance");
                         }
                       )
                  }).then(done);
            });
        });
});
