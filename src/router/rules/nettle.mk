NETTLE_CONFIGURE_ARGS+= \
	--disable-documentation \
	--with-include-path="$(TOP)/openssl/include" \
	--with-lib-path="$(TOP)/openssl , $(TOP)/gmp"
ifeq ($(ARCH),armeb)
NETTLE_CONFIGURE_ARGS+= --disable-assembler
endif
nettle-configure: pcre zlib openssl gmp
	cd nettle && ./configure --host=$(ARCH)-linux --disable-shared --enable-static --disable-pic --prefix=/usr --libdir=/usr/lib $(NETTLE_CONFIGURE_ARGS) CFLAGS="$(COPTS) $(LTO) $(MIPS16_OPT) -fPIC -ffunction-sections -fdata-sections -I$(TOP)/pcre -I$(TOP)/gmp -I$(TOP)/zlib  -fPIC" CPPFLAGS="$(COPTS) $(MIPS16_OPT) -fPIC" LDFLAGS="-L$(TOP)/pcre/.libs -L$(TOP)/gmp/.libs -lpthread -lpcre -L$(TOP)/zlib $(LDFLAGS) $(LDLTO) -lz" \
	AR_FLAGS="cru $(LTOPLUGIN)" \
	RANLIB="$(ARCH)-linux-ranlib $(LTOPLUGIN)"

nettle: openssl gmp pcre
	make -C nettle desdata CC_FOR_BUILD="gcc"
	make -C nettle CC_FOR_BUILD="gcc"

nettle-clean:
	-make -C nettle clean

nettle-install:
	@true
#	make -C nettle install DESTDIR=$(INSTALLDIR)/nettle
#	-mv $(INSTALLDIR)/nettle/usr/lib64 $(INSTALLDIR)/nettle/usr/lib
#	rm -rf $(INSTALLDIR)/nettle/usr/lib/pkgconfig
#	rm -rf $(INSTALLDIR)/nettle/usr/include
#	rm -rf $(INSTALLDIR)/nettle/usr/bin
#	rm -f $(INSTALLDIR)/nettle/usr/lib/*.a
