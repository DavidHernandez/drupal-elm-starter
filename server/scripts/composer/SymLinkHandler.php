<?php

/**
 * @file
 * Contains \DrupalProject\composer\SymLinkHandler.
 */

namespace DrupalProject\composer;

use Composer\Script\Event;
use Composer\Semver\Comparator;
use DrupalFinder\DrupalFinder;
use Symfony\Component\Filesystem\Filesystem;
use Webmozart\PathUtil\Path;

class SymLinkHandler {

  public static function linkProfile(Event $event) {
    $fs = new Filesystem();
    $drupalFinder = new DrupalFinder();
    $drupalFinder->locateRoot(getcwd());
    $drupalRoot = $drupalFinder->getDrupalRoot();

    if (!$fs->exists($drupalRoot . '/profiles/hedley')) {
      $fs->symlink($drupalRoot . '/../hedley', $drupalRoot . '/profiles/hedley');
      $event->getIO()->write("Link the profile to the Drupal installation.");
    }
  }

}
