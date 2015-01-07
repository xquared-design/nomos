<?php
/**
 * Created by PhpStorm.
 * User: Thomas
 * Date: 04/01/2015
 * Time: 6:21 PM
 */

namespace app\security;


use vhs\security\IPrincipal;

class UserPrincipal implements IPrincipal {

    private $id;
    private $permissions;

    public function __construct($id, $permissions) {
        $this->id = $id;
        $this->permissions = $permissions;
    }

    public function hasAllPermissions(...$permission) { return (count(array_diff($permission, $this->permissions)) == 0); }
    public function hasAnyPermissions(...$permission) { return (count(array_intersect($permission, $this->permissions)) > 0); }
    public function getIdentity() { return $this->id; }
    public function isAnon() { return false; }
}