require 'snmp'

class ApcSnmp
  def initialize (host, community='public', write_community='private')
    @manager = SNMP::Manager.new( :host => host, :version => :SNMPv1, :community => community, :write_community => write_community)
    @manager.load_module("PowerNet-MIB")
    @manager.load_module("RFC1213-MIB")
  end

  ## Read a single OID or an array of OIDs over SNMP
  def readValue (oid)
    response = @manager.get(oid)
    data = Array.new
    response.each_varbind do |varbind|
      data.push(varbind.value.to_s)
    end
    if data.length == 1
      return data[0]
    else
      return data
    end
  end

  ## Write a single OID with a new value
  def writeValue (name, value)
    oid = @mib.oid(name)
    varbind = SNMP::VarBind.new(oid, value)
    puts varbind
    return @manager.set(varbind)
  end

  ## Get the number of outlets from rPDUOutletDevNumCntrlOutlets
  def numOutlets ()
    return readValue("rPDUOutletDevNumCntrlOutlets.0").to_i
  end

  ## Get the status of a particular outlet or of all outlets if not specified
  def getOutletStatus (outlet=0)
    if outlet == 0
      outletList = Array.new
      outlets = numOutlets()
      for i in 1..outlets do
        outletList.push("sPDUOutletCtl.#{i}")
      end
      return readValue(outletList)
    else
      return readValue("sPDUOutletCtl.#{outlet}")
    end
  end

  ## Get the name of a particular outlet or of all outlets if not specified
  def getOutletName (outlet=0)
    if outlet == 0
      outletList = Array.new
      outlets = numOutlets()
      for i in 1..outlets do
        outletList.push("sPDUOutletName.#{i}")
      end
      return readValue(outletList)
    else
      return readValue("sPDUOutletName.#{outlet}")
    end
  end

  ## Set the name of an outlet
  def setOutletName (outlet, name)
    writeValue("sPDUOutletName.#{outlet}", SNMP::OctetString.new(name))
  end

  ## Get the name of the PDU
  def getPDUName ()
    return readValue("rPDUIdentName.0")
  end

  ## Change the name of a PDU
  def setPDUName (name)
    return writeValue("rPDUIdentName.0", SNMP::OctetString.new(name))
  end

  ## Get the serial number of a PDU
  def getSerialNumber ()
    return readValue("rPDUIdentSerialNumber.0")
  end

  ## Get the model number of a PDU
  def getModelNumber ()
    return readValue("rPDUIdentModelNumber.0")
  end

  ## Get the firmware revision of the PDU
  def getFirmwareVersion ()
    return readValue("sPDUIdentFirmwareRev.0")
  end

  ## Get total Amp load on PDU
  def getLoadAmps ()
    return readValue("rPDULoadStatusLoad.1")
  end

  ## Get number of phases on this PDU
  def getNumPhases ()
    return readValue("rPDULoadDevNumPhases.0")
  end

  ## Get the location of the PDU
  def getLocation ()
    return readValue("RFC1213-MIB::sysLocation.0")
  end

  ## Get the load on a phase return load, max load and warning load
  def getLoadDetail(phase)
    load = Hash.new
    loaddata = readValue(["rPDULoadStatusLoad.#{phase}",
                          "rPDULoadPhaseConfigOverloadThreshold.#{phase}",
                          "rPDULoadPhaseConfigNearOverloadThreshold.#{phase}"])
    load['used'] = loaddata[0]/10 # Is reported as 2.9amps being 29
    load['max'] = loaddata[1]
    load['warn'] = loaddata[2]
    return load
  end

  ## Turn an outlet off
  def outletOff (outlet)
    return writeValue("sPDUOutletCtl.#{outlet}", SNMP::Integer.new(2))
  end

  ## Turn an outlet on
  def outletOn (outlet)
    puts "Sending 'On' to sPDUOutletCtl.#{outlet}"
    return writeValue("sPDUOutletCtl.#{outlet}", SNMP::Integer.new(1))
  end
end
