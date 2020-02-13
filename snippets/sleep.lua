--Put NodeMCU in light sleep mode indefinitely with resume callback and wake interrupt
 cfg={}
 cfg.wake_pin=3
 cfg.resume_cb=function() print("WiFi resume") end

 node.sleep(cfg)

--Put NodeMCU in light sleep mode with interrupt, resume callback and discard WiFi mode
 cfg={}
 cfg.wake_pin=3 --GPIO0
 cfg.resume_cb=function() print("WiFi resume") end
 cfg.preserve_mode=false

 node.sleep(cfg)


--do nothing
node.dsleep()
--sleep μs
node.dsleep(1000000)
--set sleep option, then sleep μs
node.dsleep(1000000, 4)
--set sleep option only
node.dsleep(nil,4)
