/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package negocio;

import java.math.BigDecimal;

/**
 *
 * @author thrash
 */
public class Cliente {
    private String idCliente;
    private char tipoId;
    private String nombre;
    private String apellido;
    private String direccion;
    private String ciudad;
    private BigDecimal telefono;
    private String correo;
    private String idRep;
    private String tipoIdRep;

    public String getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(String idCliente) {
        this.idCliente = idCliente;
    }

    public char getTipoId() {
        return tipoId;
    }

    public void setTipoId(char tipoId) {
        this.tipoId = tipoId;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getCiudad() {
        return ciudad;
    }

    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }

    public BigDecimal getTelefono() {
        return telefono;
    }

    public void setTelefono(BigDecimal telefono) {
        this.telefono = telefono;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getIdRep() {
        return idRep;
    }

    public void setIdRep(String idRep) {
        this.idRep = idRep;
    }

    public String getTipoIdRep() {
        return tipoIdRep;
    }

    public void setTipoIdRep(String tipoIdRep) {
        this.tipoIdRep = tipoIdRep;
    }
    
    
    
}
