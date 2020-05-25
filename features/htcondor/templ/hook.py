#! /usr/bin/env python
"""
Hook executed at job routing. Inegrates the condor ce jobs with
the general set of rules '/etc/condor/groups_mapping.xml'.
"""

import fileinput
import re
import logging
import xml.etree.ElementTree as ET

MAX_CHAIN_DEPTH = 5

def get_classads():
    """
    Reads the list of classAds in stdinput and puts it in a dictionnary
    """
    ca_regex = re.compile(r'^\s*([^\[=\s]+)\s*=\s*(.+)$')

    return {m.group(1) : m.group(2) for m in
            [ca_regex.match(line) for line in fileinput.input()] if m}

def load_mapper(rulesfile):
    """
    Load the rules for mapping
    """
    rules = []

    xml = ET.parse(rulesfile)

    for rule in xml.getroot():
        rule_dict = rule.__dict__['attrib']
        rule_dict['tag'] = rule.__dict__['tag']
        rules.append(rule_dict)

    return rules

def mapping(rules, tag, target, depth=0):
    """
    Performs the matching of one target string with the set of rules in rules
    """
    if depth > MAX_CHAIN_DEPTH:
        raise Exception("Max depth reached matching target string %s and tag %s with rules %s" %
                        target, tag, rules)

    for rule in rules:
        if rule['tag'] == tag:
            if 'chain' in rule:
                target = mapping(target, rules, rule['chain'], depth + 1)

            if rule['match'][-1] != '$':
                rule['match'] = rule['match'] + '.*$'

            regex = re.compile(rule['match'])
            if regex.match(target):
                return regex.sub(rule['result'].replace('$', '\\'), target)

    if depth > 0:
        return target

    raise ValueError("target %s with tag %s cannot be matched by rules %s" % (target, tag, rules))

# Uncomment this if you want to have logging for debug.
#logging.basicConfig(
#    format='%(asctime)s;%(message)s',
#    filename='/var/tmp/hook.log',
#    level=logging.INFO
#)

MAPPER = load_mapper('/etc/condor/groups_mapping.xml')

CLASSADS = get_classads()

CLASSADS['x509UserProxyVOName_Fmt'] = CLASSADS['x509UserProxyVOName']\
                                      .replace('.', '_').replace('-', '_')

MATCH_FMT = '(%(x509UserProxyVOName_Fmt)s,'
MATCH_FMT += '%(x509UserProxyFirstFQAN)s,'
MATCH_FMT += '%(x509UserProxyFirstFQAN)s,'
MATCH_FMT += 'condorce)'

MATCH = MATCH_FMT % CLASSADS

MATCH = MATCH.replace('"', '')

LIMIT = mapping(MAPPER, 'limit', MATCH)

if LIMIT != 'NONE':
    CLASSADS['ConcurrencyLimits'] = "\"%s\"" % LIMIT
CLASSADS['AcctGroup'] = "\"%s\"" % mapping(MAPPER, 'group', MATCH)
CLASSADS['AccountingGroup'] = CLASSADS['AcctGroup']
CLASSADS['AcctGroupUser'] = CLASSADS['Owner']
CLASSADS['WNTag'] = "\"%s\"" % mapping(MAPPER, 'tag', MATCH)
CLASSADS['PolicyGroup'] = "\"%s\"" % mapping(MAPPER, 'policy', MATCH)
CLASSADS['MyVOName'] = CLASSADS['x509UserProxyVOName']
CLASSADS['MyProxySubject'] = CLASSADS['x509userproxysubject']
CLASSADS['MyFQAN'] = CLASSADS['x509UserProxyFirstFQAN']

## Uncomment this if you want to have logging
##logging.info(CLASSADS)

for name, value in CLASSADS.items():
    print "%s = %s" % (name, value)
