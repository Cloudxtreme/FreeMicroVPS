<?php include("header.php"); ?>
              <section class="header-11-sub bg-midnight-blue">
                <div class="background">
                </div>
                <div class="container">
                    <div class="row">
                        <div class="col-sm-8">
                        </div>
                        <div class="col-sm-4 text-outline">
                            <h3 id="signup-form">Get a free micro VPS</h3>
                            <p>
                                Get a free server in seconds. This is 
                                not a limited trial, there are no surveys to fill out, no credit card is
                                required, and you don't even need to enter your email address. Log in 
                                with your browser or favorite SSH client.
                            </p>
                            <div class="signup-form">
                                <div class="form">
                                    <div class="form-group">
                                        <a href="//ajax.freemicrovps.com/create.php" class="js-nohref create-anon-btn"><button class="btn btn-block btn-info">Create Anonymous VPS</button></a>
                                    </div>
                                </div>
                            </div>
                            <div class="additional-links">
                                By creating a server you agree to <a href="tos.html" class="js-nohref toggle-tos-modal">Terms of Use</a> and <a href="privacy.html" class="js-nohref toggle-privacy-modal">Privacy Policy</a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <section class="price-1">
                <div class="container">
                    <h3>Account Types</h3>
                    <p class="lead">
                        Upgrade your account by registering and donating bitcoin
                    </p>
                    <div class="row plans">
                        <div class="col-sm-4">
                            <div class="plan">
                                <div class="title">Anonymous</div>
                                <div class="price">Free</div>
                                <div class="description">
                                    <a href="javascript:void(0)" data-toggle="tooltip" data-placement="right" class="tooltip-enable" title="The base OS does not count towards your disk quota"><b>250KB</b> SSD</a><br>
                                    <b>16MB</b> RAM<br>
                                    <b>12kbps</b> max bandwidth
                                </div>
                                <a class="btn btn-info js-nohref create-anon-btn" href="//ajax.freemicrovps.com/create.php">Create</a><br>
                                <small><a href="anon_restrict.html" class="js-nohref toggle-anon-restrict-modal">restrictions</a></small>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="plan">
                                <div class="title">Registered</div>
                                <div class="price">Free</div>
                                <div class="description">
                                    <a href="javascript:void(0)" data-toggle="tooltip" data-placement="right" class="tooltip-enable" title="The base OS does not count towards your disk quota"><b>1GB</b> SSD</a><br>
                                    <b>32MB</b> RAM<br>
                                    <b>56kbps</b> max bandwidth<br>
                                    <b>1</b> IPv6 address
                                </div>
                                <a class="btn btn-info toggle-reg-modal js-nohref disabled" href="#signup-form">Coming Soon</a><br>
                                <small><a href="reg_restrict.html" class="js-nohref toggle-reg-restrict-modal">restrictions</a></small>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="plan">
                                <div class="title">Supporter</div>
                                <div class="price"><a href="javascript:void(0)" class="tooltip-enable" data-toggle="tooltip" data-placement="right" title="0.005 bitcoin (about $3) per month"><i class="fa fa-btc"></i> 0.005<noscript> btc</noscript> / month</a></div>
                                <div class="description">
                                    <a href="javascript:void(0)" data-toggle="tooltip" data-placement="right" class="tooltip-enable" title="The base OS does not count towards your disk quota"><b>25GB</b> SSD</a><br>
                                    <b>128MB</b> RAM<br>
                                    <b>256kbps</b> max bandwidth<br>
                                    <b>1</b> IPv6 address<br>
                                    private LAN
                                </div>
                                <a class="btn btn-primary toggle-supp-modal js-nohref disabled" href="#signup-form">Coming Soon</a><br>
                                <small><a href="supp_restrict.html" class="js-nohref toggle-supp-restrict-modal">restrictions</a></small>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        <script>
            function func_to_str(f) { return f.toString().match(/[^]*\/\*([^]*)\*\/\}$/)[1]; }

            var privacy_policy = func_to_str(function(){/*
<?php include("privacy_text.php"); ?>
*/});
            var tos = func_to_str(function(){/*
<?php include("tos_text.php"); ?>
                                              */});
            var anon_restrict = func_to_str(function(){/*
<?php include("anon_restrict_text.php"); ?>
*/});
            var reg_restrict = func_to_str(function(){/*
<?php include("reg_restrict_text.php"); ?>
*/});
            var supp_restrict = func_to_str(function(){/*
<?php include("supp_restrict_text.php"); ?>
*/});
        </script>
<?php include("footer.php"); ?>
