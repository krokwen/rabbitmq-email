PROJECT = rabbitmq_email

DEPS = amqp_client gen_smtp
ifeq ($(EICONV),1)
DEPS += eiconv
endif

TEST_DEPS = rabbitmq_test

DEP_PLUGINS = rabbit_common/mk/rabbitmq-plugin.mk

NO_AUTOPATCH += gen_smtp eiconv

PACKAGES += gen_smtp
pkg_gen_smtp_name = gen_smtp
pkg_gen_smtp_fetch = git
pkg_gen_smtp_repo = https://github.com/gotthardp/gen_smtp.git
pkg_gen_smtp_commit = master

PACKAGES += eiconv
pkg_eiconv_name = eiconv
pkg_eiconv_fetch = git
pkg_eiconv_repo = https://github.com/zotonic/eiconv.git
pkg_eiconv_commit = master

# FIXME: Use erlang.mk patched for RabbitMQ, while waiting for PRs to be
# reviewed and merged.

ERLANG_MK_REPO = https://github.com/rabbitmq/erlang.mk.git
ERLANG_MK_COMMIT = rabbitmq-tmp

include rabbitmq-components.mk
include erlang.mk

# --------------------------------------------------------------------
# Testing.
# --------------------------------------------------------------------

samples: test/data/samples.zip tests

test/data/samples.zip:
	wget http://www.hunnysoft.com/mime/samples/samples.zip -O $@
	unzip $@ -d $(@D)

WITH_BROKER_TEST_COMMANDS := \
        eunit:test(rabbit_email_tests,[verbose,{report,{eunit_surefire,[{dir,\"test\"}]}}])

# end of file
