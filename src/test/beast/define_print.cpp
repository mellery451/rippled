//
// Copyright (c) 2013-2016 Vinnie Falco (vinnie dot falco at gmail dot com)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//

#include <ripple/beast/unit_test.h>
#include <string>

// Include this .cpp in your project to gain access to the printing suite

namespace beast {
namespace unit_test {

/** A suite that prints the list of globally defined suites. */
class print_test : public boost::beast::unit_test::suite
{
public:
    void
    run() override
    {
        using namespace boost::beast::unit_test;
        std::size_t manual = 0;
        std::size_t total = 0;

        auto prefix = [](suite_info const& s)
        {
            return s.manual() ? "|M| " : "    ";
        };

        for (auto const& s : global_suites())
        {
            log << prefix (s) << s.full_name() << '\n';

            if (s.manual())
                ++manual;
            ++total;
        }

        log <<
            amount (total, "suite") << " total, " <<
            amount (manual, "manual suite") << std::endl;

        pass();
    }
};

BEAST_DEFINE_TESTSUITE_MANUAL(print,unit_test,beast);

} // unit_test
} // beast
