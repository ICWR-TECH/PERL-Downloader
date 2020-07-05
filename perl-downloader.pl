#!/usr/bin/perl

print "##############################\n";
print "# PERL Downloader - R&D ICWR #\n";
print "##############################\n";
print "\n";

use LWP::UserAgent;
use Getopt::Long;

GetOptions(
    'url=s' => \my $url,
    'files=s' => \my $files
);

package downloader;

sub write_file
{

    my $class = shift;
    my $self = {
        'content' => shift,
        'files' => shift
    };

    {
        open my $f, '>', "$self->{files}";
        print {$f} "$self->{content}";
        close $f;
    }

}

sub get_file
{

    my $class = shift;
    my $self = {
        'url' => shift,
        'files' => shift
    };
    my $url = $self->{url};
    my $files = $self->{files};
    my $req = LWP::UserAgent->new;
    $req->agent('Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:75.0) Gecko/20100101 Firefox/75.0');
    my $response = $req->get($url);

    if ($response->is_success) {

        print "[+] Downloaded : $url\n";

        if (write_file downloader($response->content, $files)) {

            print "[+] Saving files to : $files\n";

        } else {

            print "[-] Failed saving files to : $files\n";

        }

    } else {

        print "[-] Failed download : $url\n";

    }

    bless $self, $class;

}

get_file downloader($url, $files);
